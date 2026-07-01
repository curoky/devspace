#!/usr/bin/env bash

set -xeuo pipefail
cd "$(dirname $0)" || exit 1

docker build . --network=host --file Dockerfile "${@:2}" \
  --tag curoky/devspace:gui
