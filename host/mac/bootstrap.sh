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

function setup-dotfiles() {
  if [[ ! -f /opt/homebrew/bin/dotdrop ]]; then
    brew install dotdrop
  fi
  rm -rf ~/dotbox
  ln -s ~/workspace/dotbox ~/dotbox
  dotdrop install --cfg=$HOME/dotbox/config/config.yaml --force --profile=macos
}

function setup-brew() {
  export NONINTERACTIVE=1
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
}

function setup-brew-pkgs() {
  brew bundle --force --file ~/dotbox/host/mac/conf/brew/Brewfile.work --cleanup --verbose
  brew link krb5 --force
  brew cleanup --prune=all
}

function setup-prebuilt() {
  rm -rf /tmp/prebuilt-mac.tar.gz
  curl -SL https://github.com/curoky/dotbox/releases/download/v1.0.0/output-mac.tar.gz -o /tmp/prebuilt-mac.tar.gz
  rm -rf ~/prebuilt
  mkdir ~/prebuilt
  tar -xzf /tmp/prebuilt-mac.tar.gz -C ~/prebuilt --strip-components=1
}

function setup-conda-pkgs() {
  ~/dotbox/host/mac/setup-conda-pkgs.sh
}

####################### start ######################
if [[ ! -f /opt/homebrew/bin/brew ]]; then
  setup-brew
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

setup-dotfiles
setup-brew-pkgs
setup-prebuilt

if [[ ! -d /opt/homebrew/Caskroom/miniconda/base/envs/py3 ]]; then
  setup-conda-pkgs
fi
