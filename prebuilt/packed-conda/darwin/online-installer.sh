#!/usr/bin/env bash
set -xeuo pipefail

curl -L -o /tmp/conda.darwin-arm64.gzip.sh https://github.com/curoky/dotbox/releases/download/v1.0/conda.darwin-arm64.gzip.sh
bash /tmp/conda.darwin-arm64.gzip.sh $@

# Usage
# curl -sSL https://github.com/curoky/dotbox/raw/dev/prebuilt/packed-conda/darwin/online-installer.sh | bash
