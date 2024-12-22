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

source ./common.sh

# task --list-all | sed -e 's/://g' -e 's/*//g'
pkgs=(
  bzip2
  xz
  zstd
  zip
  unzip
  gettext
  m4
  gnupatch
  netcat
  lsof
  connect
  inetutils
  ncdu_1
  coreutils
  silver-searcher
  rsync
  aria2
  zsh
  vim
  git-lfs
  gost
  fzf
  shfmt
  go-task

  vim-bundle
  zsh-bundle
  rime-bundle
)
rm -rf tmp

for pkg in "${pkgs[@]}"; do
  download_pkg ${pkg} darwin_arm64 &
done
wait

rm -rf tmp/prebuilt/pkgs/zsh
remove_unneeded

rename_wrapped
link_to_bin
add_dotbox

ln -s -r tmp/prebuilt/bin/vim tmp/prebuilt/bin/vi

cd tmp
tar -czf prebuilt.darwin_arm64.tar.gz prebuilt
