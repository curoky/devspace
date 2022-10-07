#!/usr/bin/env bash
# Copyright (c) 2018-2022 curoky(cccuroky@gmail.com).
#
# This file is part of dotbox.
# See https://github.com/curoky/dotbox.git for further info.
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

# nix-env -iA \
nix-env -p /nix/var/nix/profiles/default -iA \
  nixpkgs.autoconf nixpkgs.automake nixpkgs.libtool nixpkgs.pkg-config nixpkgs.gnumake \
  nixpkgs.cmake nixpkgs.ninja nixpkgs.distcc nixpkgs.ccache nixpkgs.scons \
  nixpkgs.meson nixpkgs.ant nixpkgs.bazel_5 nixpkgs.conan \
  nixpkgs.poetry nixpkgs.yarn nixpkgs.pipenv nixpkgs.gradle nixpkgs.maven \
  nixpkgs.pre-commit nixpkgs.nodePackages.prettier nixpkgs.yapf nixpkgs.shfmt \
  nixpkgs.buildifier nixpkgs.nodePackages.eslint nixpkgs.lua \
  nixpkgs.nodejs nixpkgs.go_1_19 nixpkgs.ruby \
  nixpkgs.rustup nixpkgs.openjdk \
  nixpkgs.thrift nixpkgs.vlang nixpkgs.dotnet-sdk nixpkgs.git \
  nixpkgs.lazygit nixpkgs.git-absorb nixpkgs.git-extras nixpkgs.git-lfs nixpkgs.bzip2 \
  nixpkgs.xz nixpkgs.zstd nixpkgs.zip nixpkgs.unzip nixpkgs.iproute2 \
  nixpkgs.iputils nixpkgs.netcat nixpkgs.lsof nixpkgs.htop \
  nixpkgs.connect nixpkgs.procps nixpkgs.gost nixpkgs.nettools \
  nixpkgs.zsh nixpkgs.starship nixpkgs.direnv nixpkgs.asciinema \
  nixpkgs.tmux nixpkgs.tmuxinator nixpkgs.flex nixpkgs.bison nixpkgs.gettext \
  nixpkgs.m4 nixpkgs.gnupatch nixpkgs.jq nixpkgs.vim \
  nixpkgs.helix nixpkgs.wget nixpkgs.aria2 nixpkgs.rsync nixpkgs.gdb \
  nixpkgs.ncdu nixpkgs.file nixpkgs.silver-searcher nixpkgs.gperf nixpkgs.watchman \
  nixpkgs.nnn nixpkgs.ranger nixpkgs.exa nixpkgs.fzf nixpkgs.bat \
  nixpkgs.cloc nixpkgs.atuin nixpkgs.go-task nixpkgs.krb5 nixpkgs.less \
  nixpkgs.navi nixpkgs.ghq nixpkgs.lcov nixpkgs.gcovr \
  nixpkgs.opencc nixpkgs.dolt nixpkgs.include-what-you-use nixpkgs.mold nixpkgs.parallel \
  nixpkgs.fd nixpkgs.wishlist nixpkgs.sqlcipher nixpkgs.sqlite \
  nixpkgs.zoxide nixpkgs.mkdocs nixpkgs.sphinx nixpkgs.hugo nixpkgs.protobuf nixpkgs.buck \
  nixpkgs.clang-tools_14 nixpkgs.cmake-format nixpkgs.shellcheck nixpkgs.pandoc nixpkgs.dstat \
  nixpkgs.rustup nixpkgs.flamegraph nixpkgs.flutter nixpkgs.dart nixpkgs.nixpkgs-fmt \
  nixpkgs.ansible nixpkgs.earthly nixpkgs.cppcheck nixpkgs.graphviz nixpkgs.lld_14 nixpkgs.gdu

# nix-env -iA -p /nix/var/nix/profiles/gcc49 nixpkgs.gcc49
# nix-env -iA -p /nix/var/nix/profiles/gcc8 nixpkgs.gcc8
# nix-env -iA -p /nix/var/nix/profiles/gcc11 nixpkgs.gcc11
nix-env -iA -p /nix/var/nix/profiles/gcc12 nixpkgs.gcc12
nix-env -iA -p /nix/var/nix/profiles/protobuf3_17 nixpkgs.protobuf3_17
nix-env -iA -p /nix/var/nix/profiles/jdk8 nixpkgs.jdk8
nix-env -iA -p /nix/var/nix/profiles/jdk11 nixpkgs.jdk11
nix-env -iA -p /nix/var/nix/profiles/jdk17 nixpkgs.jdk
# nix-env -iA -p /nix/var/nix/profiles/perl nixpkgs.perl
# nix-env -iA -p /nix/var/nix/profiles/python2 nixpkgs.python
# nix-env -iA -p /nix/var/nix/profiles/python3 nixpkgs.python3
# nix-env -iA -p /nix/var/nix/profiles/clang-tools_10 nixpkgs.clang-tools_10
# nix-env -iA -p /nix/var/nix/profiles/clang-tools_11 nixpkgs.clang-tools_11
# nix-env -iA -p /nix/var/nix/profiles/clang-tools_12 nixpkgs.clang-tools_12
# nix-env -iA -p /nix/var/nix/profiles/clang-tools_13 nixpkgs.clang-tools_13
nix-env -iA -p /nix/var/nix/profiles/llvm14 nixpkgs.clang_14
nix-env -iA -p /nix/var/nix/profiles/llvm14 nixpkgs.clang-tools_14
nix-env -iA -p /nix/var/nix/profiles/llvm14 nixpkgs.llvmPackages_14.llvm
nix-env -iA -p /nix/var/nix/profiles/llvm14-bintools nixpkgs.llvmPackages_14.bintools-unwrapped
nix-env -iA -p /nix/var/nix/profiles/inetutils nixpkgs.inetutils
nix-env -iA -p /nix/var/nix/profiles/coreutils nixpkgs.coreutils
# nix-env -iA -p /nix/var/nix/profiles/hadoop nixpkgs.hadoop
# nix-env -iA -p /nix/var/nix/profiles/spark nixpkgs.spark
# nix-env -iA -p /nix/var/nix/profiles/flink nixpkgs.flink

nix-collect-garbage
