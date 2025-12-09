#!/usr/bin/env bash
# Copyright (c) 2018-2025 curoky(cccuroky@gmail.com).
#
# This file is part of devspace.
# See https://github.com/curoky/devspace for further info.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
set -xeuo pipefail

# export UV_LINK_MODE=copy

abspath=$(cd "$(dirname "$0")" && pwd)
env_name=${1:-py3}

rm -rf /opt/uv/${env_name}
mkdir -p /opt/uv/${env_name}

cd /opt/uv/${env_name}

cp $abspath/env/${env_name}/pyproject.toml $abspath/env/${env_name}/uv.lock /opt/uv/${env_name}
uv sync
