#!/bin/sh -l

set -euo pipefail
IFS=$'\n\t'

# Ensure that required environment variables are set
########################################################################################################################

README_FILEPATH=${README_FILEPATH:="./README.md"}
SHOW_TRACE=${SHOW_TRACE:=false}

ARGUMENT_ERROR=0

if [ -z "${DOCKERHUB_USERNAME}" ]; then
  echo "ERROR: The environment variable DOCKERHUB_USERNAME is not set!"
  ERROR=1
fi

if [ -z "${DOCKERHUB_PASSWORD}" ]; then
  echo "ERROR: The environment variable DOCKERHUB_PASSWORD is not set!"
  ERROR=1
fi

if [ -z "${DOCKERHUB_REPOSITORY}" ]; then
  echo "ERROR: The environment variable DOCKERHUB_REPOSITORY is not set!"
  ERROR=1
fi

if [ ${ARGUMENT_ERROR} -ne 0 ]; then
  exit 1
fi

# Prepare temporary files
########################################################################################################################

CURL_OUTPUT_FILE=$(mktemp)
CURL_TRACE_FILE=$(mktemp)

function cleanup {
  rm -f ${CURL_OUTPUT_FILE}
  rm -f ${CURL_TRACE_FILE}
}

trap cleanup EXIT

# Acquire a token for the Docker Hub API
########################################################################################################################

echo
echo "################################################################################"
echo "Acquiring access token for Docker Hub API..."
echo "################################################################################"

# authenticate at the Docker Hub
LOGIN_PAYLOAD="{\"username\": \"${DOCKERHUB_USERNAME}\", \"password\": \"${DOCKERHUB_PASSWORD}\"}"
if [ "${SHOW_TRACE}" = "true" ]; then
  RESPONSE_CODE=$(curl -s --write-out %{response_code} --output ${CURL_OUTPUT_FILE} -H "Content-Type: application/json" -X POST -d ${LOGIN_PAYLOAD} https://hub.docker.com/v2/users/login/ --trace ${CURL_TRACE_FILE})
  echo "---- Connection Trace Start -----"
  cat ${CURL_TRACE_FILE}
  echo
  echo "---- Connection Trace End -----"
else
  RESPONSE_CODE=$(curl -s --write-out %{response_code} --output ${CURL_OUTPUT_FILE} -H "Content-Type: application/json" -X POST -d ${LOGIN_PAYLOAD} https://hub.docker.com/v2/users/login/)
fi

# evaluate response code
if [ ${RESPONSE_CODE} -eq 200 ]; then
  echo "The token was acquired successfully."
else
  echo "ERROR: Acquiring the token failed!"
  echo "The server sent the following response:"
  echo "Response Code: ${RESPONSE_CODE}"
  echo "Response Data: `cat ${CURL_OUTPUT_FILE}`"
  exit 1
fi

# extract token from response
TOKEN=$(cat ${CURL_OUTPUT_FILE} | jq -r .token)

# Send a PATCH request to update the description of the repository
########################################################################################################################

echo
echo "################################################################################"
echo "Update full description of the docker image..."
echo "################################################################################"

# send request to update the full description
README=$(cat ${README_FILEPATH})
REQUEST_BODY=$( jq -n --arg full_description "${README}" '{ full_description: $full_description }' )
REPO_URL="https://hub.docker.com/v2/repositories/${DOCKERHUB_REPOSITORY}/"
if [ "${SHOW_TRACE}" = "true" ]; then
  RESPONSE_CODE=$(curl -s --write-out %{response_code} --output ${CURL_OUTPUT_FILE} -X PATCH -H "Authorization: JWT ${TOKEN}" -H "Content-Type: application/json" -d "${REQUEST_BODY}" ${REPO_URL} --trace ${CURL_TRACE_FILE})
  echo "---- Connection Trace Start -----"
  cat ${CURL_TRACE_FILE}
  echo
  echo "---- Connection Trace End -----"
else
  RESPONSE_CODE=$(curl -s --write-out %{response_code} --output ${CURL_OUTPUT_FILE} -X PATCH -H "Authorization: JWT ${TOKEN}" -H "Content-Type: application/json" -d "${REQUEST_BODY}" ${REPO_URL})
fi

# evaluate response code
if [ ${RESPONSE_CODE} -eq 200 ]; then
  echo "The description was updated successfully."
  exit 0
else
  echo "ERROR: Setting the description failed!"
  echo "The server sent the following response:"
  echo "Response Code: ${RESPONSE_CODE}"
  echo "Response Data: `cat ${CURL_OUTPUT_FILE}`"
  exit 1
fi
