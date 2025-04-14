#!/usr/bin/env bash
set -xeuo pipefail

abspath=$(cd "$(dirname "$0")" && pwd)

rm -rf /Users/x/app/conda
mkdir -p /Users/x/app/conda
chown "$(id -u):$(id -g)" /Users/x/app/conda

cp -r $abspath/* /Users/x/app/conda
