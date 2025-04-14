#!/usr/bin/env bash
set -xeuo pipefail

abspath=$(cd "$(dirname "$0")" && pwd)
target=${1:-/tmp/prebuilt}

rm -rf $target
mkdir -p $target
cp -r $abspath/* $target
