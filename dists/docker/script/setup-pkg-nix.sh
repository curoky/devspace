#!/usr/bin/env bash
# Copyright (c) 2018-2022 curoky(cccuroky@gmail.com).
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

export PATH=/nix/var/nix/profiles/default/bin:$PATH

# brew bundle list --file /opt/dotbox/config/brew/Brewfile.linux | xargs -n 15
# brew bundle list --file /opt/dotbox/config/brew/Brewfile.linux | awk '{print "nixpkgs."$0}' | xargs -n 5 | awk '{print $0" \ \"}'

# The following packages are not working properly with nix.
# nixpkgs.cmake nixpkgs.conan nixpkgs.autoconf nixpkgs.bazel_5

pkg_list=(
  # build tools
  nixpkgs.automake nixpkgs.libtool nixpkgs.pkg-config nixpkgs.gnumake nixpkgs.ninja nixpkgs.distcc
  nixpkgs.ccache nixpkgs.poetry nixpkgs.yarn nixpkgs.pipenv nixpkgs.gradle nixpkgs.maven
  # nixpkgs.buck nixpkgs.scons nixpkgs.meson nixpkgs.ant
  nixpkgs.include-what-you-use nixpkgs.mold nixpkgs.clang-tools_14 nixpkgs.lld_14
  nixpkgs.nodejs nixpkgs.go_1_19 nixpkgs.ruby # nixpkgs.lua nixpkgs.vlang nixpkgs.rustup
  # formatter and linter
  nixpkgs.pre-commit nixpkgs.nodePackages.prettier nixpkgs.yapf nixpkgs.nixpkgs-fmt
  nixpkgs.shfmt nixpkgs.buildifier nixpkgs.nodePackages.eslint nixpkgs.cppcheck
  nixpkgs.cmake-format nixpkgs.shellcheck
  # git
  nixpkgs.git nixpkgs.lazygit nixpkgs.git-absorb nixpkgs.git-extras nixpkgs.git-lfs
  nixpkgs.git-filter-repo
  # compress
  nixpkgs.bzip2 nixpkgs.xz nixpkgs.zstd nixpkgs.zip nixpkgs.unzip
  # sre
  nixpkgs.iproute2 nixpkgs.iputils nixpkgs.netcat nixpkgs.lsof nixpkgs.htop nixpkgs.connect
  nixpkgs.procps nixpkgs.gost nixpkgs.nettools nixpkgs.fd nixpkgs.ethtool nixpkgs.tcpdump
  nixpkgs.dstat nixpkgs.wget nixpkgs.aria2 nixpkgs.rsync nixpkgs.file nixpkgs.gperf
  nixpkgs.gdb
  # doc
  nixpkgs.mkdocs nixpkgs.sphinx nixpkgs.hugo nixpkgs.pandoc
  # shell
  nixpkgs.zsh nixpkgs.starship nixpkgs.direnv nixpkgs.tmux nixpkgs.tmuxinator
  # editor
  nixpkgs.flex nixpkgs.bison nixpkgs.helix nixpkgs.gnupatch nixpkgs.gettext nixpkgs.m4
  nixpkgs.jq nixpkgs.vim nixpkgs.bat nixpkgs.less
  # tools
  nixpkgs.graphviz nixpkgs.asciinema nixpkgs.gdu nixpkgs.jemalloc nixpkgs.ncdu
  nixpkgs.silver-searcher nixpkgs.watchman nixpkgs.opencc nixpkgs.dolt nixpkgs.parallel
  nixpkgs.exa nixpkgs.fzf nixpkgs.cloc                    # nixpkgs.atuin nixpkgs.nnn nixpkgs.ranger
  nixpkgs.go-task nixpkgs.krb5 nixpkgs.lcov nixpkgs.gcovr # nixpkgs.navi nixpkgs.ghq
  nixpkgs.wishlist nixpkgs.sqlcipher nixpkgs.sqlite nixpkgs.zoxide
  nixpkgs.flamegraph nixpkgs.ansible nixpkgs.earthly
)
nix-env -p /nix/var/nix/profiles/default -iA "${pkg_list[@]}"

# nix-env -iA -p /nix/var/nix/profiles/gcc49 nixpkgs.gcc49
# nix-env -iA -p /nix/var/nix/profiles/gcc12 nixpkgs.gcc12
# nix-env -iA -p /nix/var/nix/profiles/flutter nixpkgs.flutter
# nix-env -iA -p /nix/var/nix/profiles/dart nixpkgs.dart
nix-env -iA -p /nix/var/nix/profiles/protobuf3_17 nixpkgs.protobuf3_17
nix-env -iA -p /nix/var/nix/profiles/jdk8 nixpkgs.jdk8
nix-env -iA -p /nix/var/nix/profiles/jdk11 nixpkgs.jdk11
nix-env -iA -p /nix/var/nix/profiles/jdk19 nixpkgs.jdk19
# nix-env -iA -p /nix/var/nix/profiles/dotnet nixpkgs.dotnet-sdk
# nix-env -iA -p /nix/var/nix/profiles/perl nixpkgs.perl
# nix-env -iA -p /nix/var/nix/profiles/python2 nixpkgs.python
# nix-env -iA -p /nix/var/nix/profiles/python3 nixpkgs.python3
# nix-env -iA -p /nix/var/nix/profiles/clang-tools_13 nixpkgs.clang-tools_13
nix-env -iA -p /nix/var/nix/profiles/llvm14 nixpkgs.clang_14
nix-env -iA -p /nix/var/nix/profiles/llvm14 nixpkgs.clang-tools_14
nix-env -iA -p /nix/var/nix/profiles/llvm14 nixpkgs.llvmPackages_14.llvm
nix-env -iA -p /nix/var/nix/profiles/llvm14-bintools nixpkgs.llvmPackages_14.bintools-unwrapped
nix-env -iA -p /nix/var/nix/profiles/inetutils nixpkgs.inetutils
nix-env -iA -p /nix/var/nix/profiles/coreutils nixpkgs.coreutils

nix-collect-garbage
