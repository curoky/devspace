#!/usr/bin/env bash
set -xeuo pipefail

docker buildx build . \
  --file Dockerfile.gcc-14.2.0 \
  --network=host \
  --tag curoky/dotbox:stage-gcc-14.2.0
