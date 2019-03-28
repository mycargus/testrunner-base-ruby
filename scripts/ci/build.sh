#!/usr/bin/env bash

# Continuous integration script

set -ev

function cleanup()
{
  exit_code=$?

  echo ":: Cleaning up"

  docker rm -fv $(docker ps -a -q) &> /dev/null

  if [[ "${exit_code}" == "0" ]]; then
    echo ":: It's working!"
  else
    echo ":: Build Failed :("
  fi
}

trap cleanup INT TERM EXIT

docker build . -t testrunner
docker run --rm -it testrunner
