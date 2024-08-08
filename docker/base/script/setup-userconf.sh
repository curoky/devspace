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

CONF_PATH=${1:-/app/dotbox/config}

function copy_path() {
  src=$1
  dst=$2
  force=${3:-0}
  if [[ ! -e $src ]]; then
    echo "Path $src does not exist"
    if [[ $force -eq 0 ]]; then
      return
    fi
  fi
  if [[ -e $dst ]]; then
    echo "Path $dst already exists, remove it"
    rm -rf $dst
  fi
  mkdir -p $(dirname $dst)
  cp -r $src $dst
  chmod 600 $dst
  echo "Copied $src to $dst"
}

function link_path() {
  src=$1
  dst=$2
  force=${3:-0}
  if [[ ! -e $src ]]; then
    echo "Path $src does not exist"
    if [[ $force -eq 0 ]]; then
      return
    fi
  fi
  if [[ -e $dst ]]; then
    echo "Path $dst already exists, remove it"
    rm -rf $dst
  fi
  mkdir -p $(dirname $dst)
  ln -s $src $dst
  echo "Linked $src to $dst"
}

link_path $CONF_PATH/conda/condarc ~/.config/conda/condarc
link_path $CONF_PATH/croc/classic_enabled ~/.config/croc/classic_enabled
link_path $CONF_PATH/gdb/gdbinit ~/.gdbinit
link_path $CONF_PATH/nixpkgs/config.nix ~/.config/nixpkgs/config.nix
link_path $CONF_PATH/procps/toprc ~/.config/procps/toprc
link_path $CONF_PATH/vim/vimrc ~/.vimrc
link_path $CONF_PATH/atuin/config.toml ~/.config/atuin/config.toml
link_path $CONF_PATH/vscode/remote-server-settings.json ~/.vscode-server/data/Machine/settings.json
link_path ~/.local/state/nix/profiles/profile ~/.nix-profile 1
link_path ~/.local/state/nix/profiles/channels ~/.nix-defexpr/channels 1

copy_path $CONF_PATH/zsh/zshrc ~/.zshrc
copy_path $CONF_PATH/git/.gitconfig ~/.gitconfig
copy_path $CONF_PATH/ssh/user.ssh_config ~/.ssh/config
