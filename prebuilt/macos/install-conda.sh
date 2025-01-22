#!/usr/bin/env bash
set -xeuo pipefail

sudo rm -rf /opt/conda
sudo mkdir /opt/conda
sudo chown "$(id -u):$(id -g)" /opt/conda

curl -L -o /tmp/conda.darwin_arm64.tar.gz \
  https://github.com/curoky/dotbox/releases/download/v1.0/conda.darwin_arm64.tar.gz
tar -x --gunzip -f /tmp/conda.darwin_arm64.tar.gz -C /opt/conda --strip-components=2
rm -rf /tmp/conda.darwin_arm64.tar.gz
