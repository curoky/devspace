#!/usr/bin/env bash
set -xeuo pipefail

sudo rm -rf /opt/conda
sudo mkdir /opt/conda
sudo chown "$(id -u):$(id -g)" /opt/conda

tar -x --gunzip -f tmp/conda.darwin_arm64.tar.gz -C /opt/conda --strip-components=2
