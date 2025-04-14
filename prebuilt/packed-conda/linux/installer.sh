#!/usr/bin/env bash
set -xeuo pipefail

abspath=$(cd "$(dirname "$0")" && pwd)

rm -rf /opt/conda
mkdir -p /opt/conda
chown "$(id -u):$(id -g)" /opt/conda

cp -r $abspath/* /opt/conda
