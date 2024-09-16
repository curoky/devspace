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

rm -rf /tmp/prebuilt.tar.zip
curl -SL https://github.com/curoky/dotbox/releases/download/v1.0.0/prebuilt.zip -o /tmp/prebuilt.tar.zip
unzip -o /tmp/prebuilt.tar.zip -d /tmp/prebuilt.tar

rm -rf ~/prebuilt
mkdir ~/prebuilt
tar -xf /tmp/prebuilt.tar/output.tar -C ~/prebuilt --strip-components=1

# add to path
echo 'export PATH=$HOME/prebuilt/bin:$PATH' >>~/.bashrc
echo 'export PATH=$HOME/prebuilt/bin:$PATH' >>~/.profile

# link dotbox
if [[ -L ~/dotbox ]]; then
  rm -f ~/dotbox
fi

~/prebuilt/dotbox/docker/base/script/setup-userconf.sh ~/prebuilt/dotbox/config
rm -rf ~/.gitconfig
rm -rf ~/.ssh/config
