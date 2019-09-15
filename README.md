# Docker Hub Description

[![Build Status](https://dev.azure.com/griffinplus/Docker%20Images/_apis/build/status/11?branchName=master)](https://dev.azure.com/griffinplus/Docker%20Images/_build/latest?definitionId=11&branchName=master)
[![Docker Pulls](https://img.shields.io/docker/pulls/griffinplus/dockerhub-description.svg)](https://hub.docker.com/r/griffinplus/dockerhub-description)
[![Github Stars](https://img.shields.io/github/stars/griffinplus/docker-dockerhub-description.svg?label=github%20%E2%98%85)](https://github.com/griffinplus/docker-dockerhub-description)
[![Github Contributors](https://img.shields.io/github/contributors/griffinplus/docker-dockerhub-description.svg)](https://github.com/griffinplus/docker-dockerhub-description)
[![Github Forks](https://img.shields.io/github/forks/griffinplus/docker-dockerhub-description.svg?label=github%20forks)](https://github.com/griffinplus/docker-dockerhub-description)



This docker image updates the description of an image at the [Docker Hub](https://hub.docker.com/).

It is based on the [work](https://github.com/peter-evans/dockerhub-description) of Peter Evans.

## Using

To update the description of an image at the Docker Hub, you simply need to mount the markdown file to use as the image
description into the container and set environment variables as follows:

```shell
docker run \
  -v $PWD:/workspace \
  -e DOCKERHUB_USERNAME='<username>' \
  -e DOCKERHUB_PASSWORD='<password>' \
  -e DOCKERHUB_REPOSITORY='<namespace>/<image>' \
  -e README_FILEPATH='/workspace/README.md' \
  griffinplus/dockerhub-description
```

## Environment Variables

#### >>> DOCKERHUB_USERNAME ***[mandatory]***

Docker Hub username. If updating a Docker Hub repository belonging to an organization, this user must have `Admin`
permissions for the repository.

#### >>> DOCKERHUB_PASSWORD ***[mandatory]***

Docker Hub password.

#### >>> DOCKERHUB_REPOSITORY ***[mandatory]***

The Docker Hub repository to update in the format `<namespace>/<name>`.

#### >>> README_FILEPATH

Path to the markdown file to upload to Docker Hub.

Default: `/README.md`

#### >>> SHOW_TRACE

Determines whether the container emits a connection trace for issued HTTP requests. This can help to debug
connection issues. These traces can contain sensitive information. Can be: `true`, `false`

Default: `false`

## License

This project is under the MIT License - see the [LICENSE](LICENSE) file for details.
