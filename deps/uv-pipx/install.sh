#!/usr/bin/env bash

set -xeuo pipefail
abspath=$(cd "$(dirname "$0")" && pwd)

rm -rf /opt/pipx
mkdir -p /opt/pipx

cp $abspath/pyproject.toml $abspath/uv.lock $abspath/pipx /opt/pipx

cd /opt/pipx

export UV_LINK_MODE=copy
uv sync
