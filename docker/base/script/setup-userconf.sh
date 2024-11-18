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

CONF_PATH=${1:-$HOME/dotbox/config}

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
    echo "Path $dst already exists, move it to backup"
    mv $dst ${dst}.bk
  fi
  mkdir -p $(dirname $dst)
  cp -r $src $dst
  chmod 600 $dst
  echo "Copied $src to $dst"
}

function link_path() {
  src=$1
  dst=$2
  ignore_source_not_exist=${3:-0}
  if [[ ! -e $src ]]; then
    echo "Path $src does not exist"
    if [[ $ignore_source_not_exist -eq 0 ]]; then
      return
    fi
  fi
  if [[ -e $dst ]] || [[ -L $dst ]]; then
    echo "Path $dst already exists, move it to backup"
    mv $dst ${dst}.bk
  fi
  mkdir -p $(dirname $dst)
  ln -s $src $dst
  echo "Linked $src to $dst"
}

link_path $CONF_PATH/conda/condarc ~/.config/conda/condarc
link_path $CONF_PATH/croc/classic_enabled ~/.config/croc/classic_enabled
link_path $CONF_PATH/nixpkgs/config.nix ~/.config/nixpkgs/config.nix
link_path $CONF_PATH/procps/toprc ~/.config/procps/toprc
link_path $CONF_PATH/tmux/tmux.conf ~/.config/tmux/tmux.conf
link_path $CONF_PATH/atuin/config.toml ~/.config/atuin/config.toml
link_path $CONF_PATH/starship/starship.toml ~/.config/starship.toml
link_path $CONF_PATH/bat/config ~/.config/bat/config
link_path $CONF_PATH/go/env ~/.config/go/env

link_path $CONF_PATH/gdb/gdbinit ~/.gdbinit
link_path $CONF_PATH/vim/vimrc ~/.vimrc

link_path $CONF_PATH/vscode/remote-server-settings.json ~/.vscode-server/data/Machine/settings.json
# link_path $CONF_PATH/tabby-ml/config.toml ~/.tabby-client/agent/config.toml

copy_path $CONF_PATH/zsh/prune.zshrc ~/.zshrc
copy_path $CONF_PATH/git/.gitconfig ~/.gitconfig
copy_path $CONF_PATH/ssh/user.ssh_config ~/.ssh/config
