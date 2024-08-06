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

# reset dotfiles for x
if [[ -d /data/share/dotbox ]]; then
  rm -rf /home/x/dotbox
  ln -s /data/share/dotbox /home/x/dotbox
fi

if [[ -d /workspace/dotbox ]]; then
  rm -rf /home/x/dotbox
  ln -s /workspace/dotbox /home/x/dotbox
fi

# setup cache dir
if [[ -d /data/cache ]]; then
  chown x:x /data/cache
  rm -rf /home/x/.cache
  ln -s /data/cache /home/x/.cache
fi

# setup vscode-server cache
if [[ -d /data/cache/vscode-server ]]; then
  rm -rf /home/x/.vscode-server
  ln -s /data/cache/vscode-server /home/x/.vscode-server
  chown x:x /data/cache/vscode-server
fi

chown x:x /workspace
