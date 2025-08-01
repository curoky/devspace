#!/usr/bin/env bash
# Copyright (c) 2018-2025 curoky(cccuroky@gmail.com).
#
# This file is part of devspace.
# See https://github.com/curoky/devspace for further info.
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
  rime-extra
  rsync
  shfmt
  starship
  unzip
  vim-extra
  xz
  zip
  zsh-bundle
  zstd
  buildifier
  ripgrep
  # tmux
  tmux-extra

  lxgw-wenkai
  fira-code
  # nerd-fonts.fira-code
  nerd-fonts.ubuntu-mono
  # iina
  # snipaste
  # keka
  # obs-studio

  ##### unneeded
  # vim
  # zsh
  # aria2
  # gost

  # ruff need link jemalloc
)
rm -rf tmp && mkdir tmp
mkdir -p tmp/tools/{bin,etc,include,downloads,lib,libexec,profile,share,store}

curl https://raw.githubusercontent.com/curoky/static-binaries/refs/heads/master/tools/multi-install.sh >tmp/install.sh
for pkg in "${pkgs[@]}"; do
  bash tmp/install.sh -n $pkg -i tmp/tools -l -p tmp/tools -a darwin-arm64 &
done
wait

# https://github.com/wulkano/Kap/releases
# https://github.com/wulkano/Kap/releases/download/v3.6.0/Kap-3.6.0-arm64-mac.zip

# https://github.com/iina/iina/releases
# https://github.com/iina/iina/releases/download/v1.3.5/IINA.v1.3.5.dmg

# https://zh.snipaste.com/download.html
# https://download.snipaste.com/archives/Snipaste-2.10.8.dmg

# https://github.com/newmarcel/KeepingYouAwake/releases
# https://github.com/newmarcel/KeepingYouAwake/releases/download/1.6.7/KeepingYouAwake-1.6.7.zip

# https://download.bjango.com/istatmenus6/
# https://cdn.istatmenus.app/files/istatmenus6/istatmenus6.73.1.zip

# https://github.com/obsproject/obs-studio/releases
# https://cdn-fastly.obsproject.com/downloads/obs-studio-31.1.2-macos-apple.dmg
# https://github.com/obsproject/obs-studio/releases/download/31.1.2/OBS-Studio-31.1.2-macOS-Apple.dmg

# https://github.com/aonez/Keka/releases
# https://github.com/aonez/Keka/releases/download/v1.5.2/Keka-1.5.2.dmg

curl -SL -o tmp/tools/downloads/Kap.zip https://github.com/wulkano/Kap/releases/download/v3.6.0/Kap-3.6.0-arm64-mac.zip
curl -SL -o tmp/tools/downloads/KeepingYouAwake.zip https://github.com/newmarcel/KeepingYouAwake/releases/download/1.6.7/KeepingYouAwake-1.6.7.zip
curl -SL -o tmp/tools/downloads/istatmenus6.zip https://cdn.istatmenus.app/files/istatmenus6/istatmenus6.73.1.zip
curl -SL -o tmp/tools/downloads/OBS-Studio.dmg https://github.com/obsproject/obs-studio/releases/download/31.1.2/OBS-Studio-31.1.2-macOS-Apple.dmg
curl -SL -o tmp/tools/downloads/Snipaste.dmg https://download.snipaste.com/archives/Snipaste-2.10.8.dmg
curl -SL -o tmp/tools/downloads/IINA.dmg https://github.com/iina/iina/releases/download/v1.3.5/IINA.v1.3.5.dmg
curl -SL -o tmp/tools/downloads/Keka.dmg https://github.com/aonez/Keka/releases/download/v1.5.2/Keka-1.5.2.dmg

unzip -d tmp/tools/Library tmp/tools/downloads/Kap.zip
unzip -d tmp/tools/Library tmp/tools/downloads/KeepingYouAwake.zip
unzip -d tmp/tools/Library tmp/tools/downloads/istatmenus6.zip
cp tmp/tools/downloads/OBS-Studio.dmg tmp/tools/Library
cp tmp/tools/downloads/Snipaste.dmg tmp/tools/Library
cp tmp/tools/downloads/IINA.dmg tmp/tools/Library
cp tmp/tools/downloads/Keka.dmg tmp/tools/Library

rm -rf tmp/tools/downloads
cp -f ../common/installer.sh tmp/tools/

makeself --tar-format gnu --complevel 6 --tar-quietly --gzip --threads 16 tmp/tools tmp/tools-installer.darwin-arm64.gzip.sh "Prebuilt Installer" ./installer.sh
makeself --tar-format gnu --complevel 16 --tar-quietly --zstd --threads 16 tmp/tools tmp/tools-installer.darwin-arm64.zstd.sh "Prebuilt Installer" ./installer.sh
