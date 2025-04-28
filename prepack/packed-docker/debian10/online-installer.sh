#!/usr/bin/env bash
# Copyright (c) 2018-2025 curoky(cccuroky@gmail.com).
#
# This file is part of dotbox.
# See https://github.com/curoky/dotbox for further info.
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

if command -v zstd &>/dev/null; then
  compress_type=zstd
else
  compress_type=gzip
fi

curl -L -o /tmp/docker-installer.debian10.sh https://github.com/curoky/dotbox/releases/download/v1.0/docker-installer.debian10.${compress_type}.sh
bash /tmp/docker-installer.debian10.sh --target /tmp/docker --noexec # $@

# Usage
# curl -sSL https://github.com/curoky/dotbox/raw/dev/prepack/docker-offline-installer/debian10/online-installer.sh | bash
