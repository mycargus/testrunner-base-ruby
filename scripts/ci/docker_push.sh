#!/usr/bin/env bash

# Build and push the docker image to docker hub registry

set -ev

docker build . -t mycargus/testrunner-base-ruby:latest

echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
docker push mycargus/testrunner-base-ruby:latest
