#!/usr/bin/env bash
set -xeuo pipefail
export UV_LINK_MODE=copy

rm -rf ~/uv
mkdir -p ~/uv/envs/py3
cd ~/uv/envs/py3
uv init --no-workspace
uv venv
uv pip install -r /workspace/devspace/dist/image/stage/conda/env/py3-requirements.txt
