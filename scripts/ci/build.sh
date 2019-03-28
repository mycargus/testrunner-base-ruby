#!/usr/bin/env bash

# Continuous integration script

set -ev

container_name=testrunner

function cleanup()
{
  exit_code=$?

  echo ":: Cleaning up"

  docker rm -fv "$container_name" || true

  if [[ "${exit_code}" == "0" ]]; then
    echo ":: It's working!"
  else
    echo ":: Build Failed :("
  fi
}

trap cleanup INT TERM EXIT

docker build --pull . -t testrunner

# lint
docker run --rm -it --name "$container_name" testrunner rubocop

# test
docker run --rm -it --name "$container_name" testrunner
