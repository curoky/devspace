#!/usr/bin/env bash

set -xeuo pipefail
abspath=$(cd "$(dirname "$0")" && pwd)

rm -rf /opt/pipx
mkdir -p /opt/pipx/bin

cp $abspath/pyproject.toml $abspath/uv.lock /opt/pipx
cp $abspath/pipx /opt/pipx/bin

cd /opt/pipx

# export UV_LINK_MODE=copy
uv sync
