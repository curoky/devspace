#!/usr/bin/env bash
set -xeuo pipefail

rm -rf .venv pyproject.toml uv.lock
uv init --no-workspace
uv add -r /workspace/devspace/images/base/stage/conda/env/monopoly.yaml
uv sync
