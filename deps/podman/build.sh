#!/usr/bin/env bash
set -xeuo pipefail

docker buildx build . \
  --file Dockerfile \
  --network=host \
  --build-arg="GCC_VERSION=14.2.0" \
  --tag curoky/devspace:prebuilt-podman

id=$(docker create curoky/devspace:prebuilt-podman)
docker cp $id:/opt/podman - >podman.tar
rm -rf packed
tar -x -f podman.tar
