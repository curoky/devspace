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

install_prefix=${1:-~/prebuilt}

rm -rf /tmp/prebuilt.tar.gz
curl -SL https://github.com/curoky/dotbox/releases/download/v1.0.0/prebuilt.tar.gz -o /tmp/prebuilt.tar.gz
rm -rf $install_prefix
mkdir $install_prefix
tar -xzf /tmp/prebuilt.tar.gz -C $install_prefix --strip-components=1

# add to path
if ! grep -q 'prebuilt/bin' ~/.bashrc; then
  echo 'export PATH=$HOME/prebuilt/bin:$PATH' >>~/.bashrc
fi
if ! grep -q 'prebuilt/bin' ~/.profile; then
  echo 'export PATH=$HOME/prebuilt/bin:$PATH' >>~/.profile
fi

# link dotbox
if [[ -L ~/dotbox ]]; then
  rm -f ~/dotbox
fi
rm -rf $install_prefix/dotbox
mkdir -p $install_prefix/dotbox
curl -sSL https://github.com/curoky/dotbox/archive/refs/heads/master.tar.gz |
  tar -xv --gunzip -C $install_prefix/dotbox --strip-components 1
ln -s $install_prefix/dotbox ~/dotbox

rm -rf ~/.nix-profile
rm -rf ~/.nix-defexpr/channels

$install_prefix/dotbox/docker/base/script/setup-userconf.sh $install_prefix/dotbox/config
rm -rf ~/.gitconfig
rm -rf ~/.ssh/config
