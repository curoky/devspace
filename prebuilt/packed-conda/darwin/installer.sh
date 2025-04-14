#!/usr/bin/env bash
set -xeuo pipefail

abspath=$(cd "$(dirname "$0")" && pwd)

sudo rm -rf /opt/conda
sudo mkdir -p /opt/conda
sudo chown "$(id -u):$(id -g)" /opt/conda

cp -r $abspath/* /opt/conda
