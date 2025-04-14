#!/usr/bin/env bash
set -xeuo pipefail

if command -v zstd &>/dev/null; then
  compress_type=zstd
else
  compress_type=gzip
fi

curl -L -o /tmp/conda.darwin-arm64.sh https://github.com/curoky/dotbox/releases/download/v1.0/conda.darwin-arm64.${compress_type}.sh
bash /tmp/conda.darwin-arm64.sh $@

# Usage
# curl -sSL https://github.com/curoky/dotbox/raw/dev/prebuilt/packed-conda/darwin/online-installer.sh | bash
