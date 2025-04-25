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

# source ../common/utils.sh

# task --list-all | sed -e 's/://g' -e 's/*//g'
pkgs=(
  atuin
  bat
  bzip2
  connect
  coreutils
  eza
  fd
  findutils
  fzf
  gawk
  gdu
  getopt
  gettext
  git-absorb
  git-extras
  git-lfs
  gnugrep
  gnupatch
  gnused
  gnutar
  go-task
  inetutils
  lsof
  m4
  makeself
  ncdu_1
  netcat
  openssl
  rime-bundle
  rsync
  shfmt
  silver-searcher
  starship
  unzip
  vim-bundle
  xz
  zip
  zsh-bundle
  zstd

  ##### unneeded
  # vim
  # zsh
  # aria2
  # gost

  # ruff need link jemalloc
)
rm -rf tmp && mkdir tmp

curl https://raw.githubusercontent.com/curoky/prebuilt-tools/refs/heads/master/tools/install.sh >tmp/install.sh
for pkg in "${pkgs[@]}"; do
  bash tmp/install.sh -n $pkg -i tmp/tools -l -p tmp/tools &
done
wait

cp -f ../common/installer.sh tmp/tools/

makeself --tar-format gnu --complevel 6 --tar-quietly --gzip --threads 16 tmp/tools tmp/tools-installer.darwin-arm64.gzip.sh "Prebuilt Installer" ./installer.sh
makeself --tar-format gnu --complevel 16 --tar-quietly --zstd --threads 16 tmp/tools tmp/tools-installer.darwin-arm64.zstd.sh "Prebuilt Installer" ./installer.sh
