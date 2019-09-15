FROM alpine:3.10

LABEL \
  maintainer="Sascha Falk <sascha@falk-online.eu>" \
  repository="https://github.com/griffinplus/docker-dockerhub-description" \
  homepage="https://github.com/griffinplus/docker-dockerhub-description" \
  org.opencontainers.image.title="dockerhub-description" \
  org.opencontainers.image.description="An updater for image descriptions at the Docker Hub" \
  org.opencontainers.image.authors="Sascha Falk <sascha@falk-online.eu>" \
  org.opencontainers.image.url="https://github.com/griffinplus/docker-dockerhub-description" \
  org.opencontainers.image.vendor="https://griffin.plus" \
  org.opencontainers.image.licenses="MIT"

RUN \
  apk update && \
  apk add --no-cache curl jq && \
  rm -rf /var/cache/apk/*

COPY LICENSE README.md entrypoint.sh /

ENTRYPOINT [ "/entrypoint.sh" ]
