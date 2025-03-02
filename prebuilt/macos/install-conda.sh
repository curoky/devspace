#!/usr/bin/env bash
set -xeuo pipefail

curl -L -o /tmp/conda.darwin-arm64.tar.gz \
  https://github.com/curoky/dotbox/releases/download/v1.0/conda.darwin-arm64.tar.gz

sudo rm -rf /opt/conda
sudo mkdir /opt/conda
sudo chown "$(id -u):$(id -g)" /opt/conda

tar -x --gunzip -f /tmp/conda.darwin-arm64.tar.gz -C /opt/conda --strip-components=2
rm -rf /tmp/conda.darwin-arm64.tar.gz
