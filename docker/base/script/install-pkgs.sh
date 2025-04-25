#!/usr/bin/env bash

set -xeuo pipefail

pkgs=(
  bzip2 clang-format_18
  connect
  dool
  ethtool
  fzf
  gdu
  go-task
  inetutils
  iproute2
  iputils
  jq
  krb5
  libcap
  lsb-release
  makeself
  miniserve
  ncdu_1
  netcat
  netron
  nettools
  openssl
  patchelf
  procps
  rsync
  silver-searcher
  snappy
  strace
  tmux
  xxd
  xz
  zlib
  zlib-ng
  zstd

  ####  too basic tool
  cacert
  curl
  diffutils
  fd
  file
  findutils
  gawk
  getopt
  gettext
  gnugrep
  gnumake
  gnupatch
  gnused
  gnutar
  gzip
  less
  lsof
  m4
  pkg-config
  tree
  unzip
  util-linux
  wget
  zip

  #### only use in docker
  atuin
  bat
  bazelisk
  bison
  buildifier
  exiftool
  eza
  flex
  git-absorb
  git-extras
  git-filter-repo
  git-lfs
  glibcLocales
  gnupg-minimal
  ninja
  openssh_gssapi
  procs
  protobuf_24
  protobuf_25
  protobuf_28
  protobuf_3_8_0
  protobuf_3_9_2
  ruff
  shfmt
  starship
  tmux-bundle
  tzdata
  vim
  vim-bundle
  zsh
  zsh-bundle

  ##### unneeded
  # aria2
  # binutils
  # coreutils
  # croc
  # dive
  # gh
  # gost
  # iptables
  # lld_18
  # nixfmt-rfc-style
  # nixpkgs-fmt
  # numactl
  # scc

  ##### experimental
  # autoconf
  # automake
  # bash
  # gdb
  # git
  # libtool
  # man
  # perl
)

curl https://raw.githubusercontent.com/curoky/prebuilt-tools/refs/heads/master/tools/install.sh >/tmp/install.sh
for pkg in "${pkgs[@]}"; do
  bash /tmp/install.sh -n $pkg -i /home/x/app/tools -l -p /home/x/app/tools/ &
done
bash /tmp/install.sh -n python311 -i /home/x/app/tools &
wait
rm -rf /home/x/app/tools/downloads

ln -s -r /home/x/app/tools/bin/bazelisk /home/x/app/tools/bin/bazel
ln -s -r /home/x/app/tools/bin/clang-format-18 /home/x/app/tools/bin/clang-format
