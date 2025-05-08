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

abspath=$(cd "$(dirname "$0")" && pwd)

target=${1:-$HOME/app/tools}

rm -rf $target
# mkdir -p $target
# cp -r $abspath/* $target
mv $abspath $target

if ! grep -q 'app/tools/bin' ~/.bashrc; then
  echo 'export PATH=$HOME/app/tools/bin:$PATH' >>~/.bashrc
fi

if ! grep -q 'app/tools/bin' ~/.profile; then
  echo 'export PATH=$HOME/app/tools/bin:$PATH' >>~/.profile
fi
