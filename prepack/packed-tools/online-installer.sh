#!/usr/bin/env bash
# Copyright (c) 2018-2024 curoky(cccuroky@gmail.com).
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

arch=$(echo $(uname -s)-$(uname -m) | tr '[:upper:]' '[:lower:]') # linux_amd64/darwin-arm64

curl -L -o /tmp/tools-installer.sh https://github.com/curoky/dotbox/releases/download/v1.0/tools-installer.${arch}.${compress_type}.sh
bash /tmp/tools-installer.sh $@

# sudo find ~/app/tools/bin -type f -exec xattr -d com.apple.quarantine {} +

# Usage
# curl -sSL https://github.com/curoky/dotbox/raw/dev/prepack/packed-tools/online-installer.sh | bash
