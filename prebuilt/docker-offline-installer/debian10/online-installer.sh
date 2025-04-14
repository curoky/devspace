#!/usr/bin/env bash
set -xeuo pipefail

curl -L -o /tmp/docker_installer.sh https://github.com/curoky/dotbox/releases/download/v1.0/docker_installer.debian10.zstd.sh
bash /tmp/docker_installer.sh $@

# Usage
# curl -sSL https://github.com/curoky/dotbox/raw/dev/prebuilt/docker-offline-installer/debian10/online-installer.sh | bash
