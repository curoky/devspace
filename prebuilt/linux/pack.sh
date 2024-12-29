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

source ../common/utils.sh

# task --list-all | sed -e 's/://g' -e 's/*//g'
pkgs=(
  aria2
  atuin
  autoconf
  automake
  bash
  bat
  bazelisk
  binutils
  bison
  buildifier
  bzip2
  cacert
  connect
  coreutils
  croc
  curl
  diffutils
  ethtool
  eza
  fd
  file
  findutils
  flex
  fzf
  gawk
  gdb
  gdu
  getopt
  gettext
  gh
  git
  git-absorb
  git-extras
  git-lfs
  glibcLocales
  gnugrep
  gnumake
  gnupatch
  gnupg-minimal
  gnused
  gnutar
  go-task
  gost
  gzip
  inetutils
  iproute2
  iptables
  iputils
  jq
  krb5
  less
  libcap
  libtool
  llvmPackages_18.clang-unwrapped
  lsb-release
  lsof
  m4
  man
  miniserve
  ncdu_1
  netcat
  nettools
  ninja
  nixfmt-rfc-style
  nixpkgs-fmt
  numactl
  openssh_gssapi
  openssl
  patchelf
  perl
  pkg-config
  procps
  procs
  protobuf_24
  protobuf_25
  protobuf_28
  protobuf_3_8_0
  protobuf_3_9_2
  python311
  rime-bundle
  rsync
  ruff
  shfmt
  silver-searcher
  snappy
  starship
  strace
  tmux
  tmux-bundle
  tree
  tzdata
  unzip
  util-linux
  vim
  vim-bundle
  wget
  xxd
  xz
  zip
  zlib
  zlib-ng
  zsh
  zsh-bundle
  zstd
)

rm -rf tmp

for pkg in "${pkgs[@]}"; do
  download_pkg ${pkg} &
done
wait

mkdir tmp/prebuilt/bin/
mkdir -p tmp/prebuilt/pkgs/clang-format-18/bin
cp tmp/prebuilt/pkgs/llvmPackages_18.clang-unwrapped/bin/clang-format tmp/prebuilt/pkgs/clang-format-18/bin/clang-format
rm -rf tmp/prebuilt/pkgs/llvmPackages_18.clang-unwrapped
rm -rf tmp/prebuilt/pkgs/rime-bundle

# some issue
touch tmp/prebuilt/pkgs/binutils/skip_link
touch tmp/prebuilt/pkgs/coreutils/skip_link

# experimental
touch tmp/prebuilt/pkgs/bash/skip_link
touch tmp/prebuilt/pkgs/git/skip_link
touch tmp/prebuilt/pkgs/perl/skip_link
touch tmp/prebuilt/pkgs/man/skip_link
touch tmp/prebuilt/pkgs/autoconf/skip_link
touch tmp/prebuilt/pkgs/automake/skip_link
touch tmp/prebuilt/pkgs/pkg-config/skip_link
touch tmp/prebuilt/pkgs/libtool/skip_link
touch tmp/prebuilt/pkgs/gdb/skip_link

# unneeded
rm -rf tmp/prebuilt/pkgs/glibcLocales
remove_unneeded

rename_wrapped
strip_bin
copy_wrapper
link_to_bin
link_zsh_comp
add_dotbox

ln -s -r tmp/prebuilt/bin/bazelisk tmp/prebuilt/bin/bazel
ln -s -r tmp/prebuilt/bin/clang-format tmp/prebuilt/bin/clang-format-18

./setup-pipx.sh
cd tmp
tar -c --gunzip -f prebuilt.linux_x86_64.tar.gz prebuilt
