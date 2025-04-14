#!/usr/bin/env bash
set -xeuo pipefail

if command -v zstd &>/dev/null; then
  compress_type=zstd
else
  compress_type=gzip
fi

curl -L -o /tmp/docker_installer.debian10.sh https://github.com/curoky/dotbox/releases/download/v1.0/docker_installer.debian10.${compress_type}.sh
bash /tmp/docker_installer.debian10.sh $@

# Usage
# curl -sSL https://github.com/curoky/dotbox/raw/dev/prebuilt/docker-offline-installer/debian10/online-installer.sh | bash
