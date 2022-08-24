#!/usr/bin/env bash
# Copyright 2019 curoky(cccuroky@gmail.com).
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

# brew list | xargs -n 1
# brew bundle list --file /opt/dotbox/config/brew/Brewfile.linux | xargs -n 15
# brew bundle list --file /opt/dotbox/config/brew/Brewfile.linux | awk '{print "nixpkgs."$0}' | xargs -n 5 | awk '{print $0" \ \"}'

# nix-env -iA \
sudo /nix/var/nix/profiles/default/bin/nix-env -iA \
  nixpkgs.autoconf nixpkgs.automake nixpkgs.libtool nixpkgs.pkg-config nixpkgs.gnumake \
  nixpkgs.cmake nixpkgs.ninja nixpkgs.distcc nixpkgs.ccache nixpkgs.scons \
  nixpkgs.meson nixpkgs.ant  nixpkgs.bazel nixpkgs.conan \
  nixpkgs.poetry nixpkgs.yarn nixpkgs.pipenv nixpkgs.gradle nixpkgs.maven \
  nixpkgs.pre-commit nixpkgs.nodePackages.prettier nixpkgs.yapf nixpkgs.shfmt \
  nixpkgs.buildifier nixpkgs.nodePackages.eslint nixpkgs.gcc nixpkgs.llvm nixpkgs.lua \
  nixpkgs.python3 nixpkgs.python nixpkgs.nodejs nixpkgs.go nixpkgs.perl nixpkgs.ruby \
  nixpkgs.rustup nixpkgs.openjdk \
  nixpkgs.thrift nixpkgs.vlang nixpkgs.dotnet-sdk nixpkgs.git \
  nixpkgs.lazygit nixpkgs.git-absorb nixpkgs.git-extras nixpkgs.git-lfs nixpkgs.bzip2 \
  nixpkgs.xz nixpkgs.zstd nixpkgs.zip nixpkgs.unzip nixpkgs.iproute2 \
  nixpkgs.iputils nixpkgs.netcat nixpkgs.lsof nixpkgs.htop \
  nixpkgs.connect nixpkgs.procps nixpkgs.gost nixpkgs.inetutils \
  nixpkgs.zsh nixpkgs.starship nixpkgs.direnv nixpkgs.asciinema \
  nixpkgs.tmux nixpkgs.tmuxinator nixpkgs.flex nixpkgs.bison nixpkgs.gettext \
  nixpkgs.m4 nixpkgs.gnupatch nixpkgs.jq nixpkgs.vim \
  nixpkgs.helix nixpkgs.wget nixpkgs.aria2 nixpkgs.rsync nixpkgs.gdb \
  nixpkgs.ncdu nixpkgs.file nixpkgs.silver-searcher nixpkgs.gperf nixpkgs.watchman \
  nixpkgs.nnn nixpkgs.ranger nixpkgs.exa nixpkgs.fzf nixpkgs.bat \
  nixpkgs.cloc nixpkgs.atuin nixpkgs.go-task nixpkgs.krb5 nixpkgs.less \
  nixpkgs.navi nixpkgs.ghq nixpkgs.lcov nixpkgs.gcovr nixpkgs.docker-compose \
  nixpkgs.opencc nixpkgs.dolt nixpkgs.include-what-you-use nixpkgs.mold nixpkgs.parallel \
  nixpkgs.fd nixpkgs.wishlist nixpkgs.coreutils nixpkgs.sqlcipher nixpkgs.sqlite \
  nixpkgs.zoxide nixpkgs.mkdocs nixpkgs.sphinx nixpkgs.hugo
