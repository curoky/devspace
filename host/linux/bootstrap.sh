#!/usr/bin/env bash
set -xeuo pipefail

curl -sSL https://github.com/curoky/devspace/raw/master/prepack/packed-devspace/online-installer.sh | bash -s -- -- -l -n host-linux/docker
curl -sSL https://github.com/curoky/devspace/raw/master/prepack/packed-tools/online-installer.sh | bash
