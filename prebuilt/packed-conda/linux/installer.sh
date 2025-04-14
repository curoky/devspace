#!/usr/bin/env bash
set -xeuo pipefail

abspath=$(cd "$(dirname "$0")" && pwd)

rm -rf /home/x/app/conda
mkdir -p /home/x/app/conda
chown "$(id -u):$(id -g)" /home/x/app/conda

cp -r $abspath/* /home/x/app/conda
