#!/usr/bin/env bash
set -xeuo pipefail

export UV_LINK_MODE=copy

abspath=$(cd "$(dirname "$0")" && pwd)
env_name=${1:-py3}

rm -rf /opt/uv
mkdir -p /opt/uv/${env_name}

cd /opt/uv/${env_name}

cp $abspath/env/${env_name}/pyproject.toml $abspath/env/${env_name}/uv.lock /opt/uv/${env_name}
uv sync
