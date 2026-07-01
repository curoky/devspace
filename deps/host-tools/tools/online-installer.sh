#!/usr/bin/env bash

set -xeuo pipefail

if command -v zstd &>/dev/null; then
  compress_type=zstd
else
  compress_type=gzip
fi

arch=$(echo $(uname -s)-$(uname -m) | tr '[:upper:]' '[:lower:]') # linux_amd64/darwin-arm64

curl -L -o /tmp/tools-installer.sh https://github.com/curoky/devspace/releases/download/v1.0/tools-installer.${arch}.${compress_type}.sh
bash /tmp/tools-installer.sh $@

# sudo find ~/app/tools/bin -type f -exec xattr -d com.apple.quarantine {} +

# Usage
# curl -sSL https://github.com/curoky/devspace/raw/master/prepack/packed-tools/online-installer.sh | bash
# curl -sSL https://github.com/curoky/devspace/raw/master/prepack/packed-tools/online-installer.sh | bash -s -- --noexec --target tmp
