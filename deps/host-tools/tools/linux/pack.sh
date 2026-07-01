#!/usr/bin/env bash

set -xeuo pipefail

pkgs=(
  # bzip2
  # clang-format_18
  # connect
  dool
  # ethtool
  # fzf
  # gdu
  go-task
  # inetutils
  # iproute2
  # iputils
  # jq
  # krb5
  # libcap
  # lsb-release
  # makeself
  miniserve
  ncdu_1
  netcat
  netron
  # nettools
  # openssl
  patchelf
  # procps
  rsync
  # snappy
  # strace
  # xxd
  # xz
  # zlib
  # zlib-ng
  zstd
  dive
  tmux
  tmux-extra
  vim
  vim-extra
  ripgrep

  ####  too basic tool
  # cacert
  # curl
  # diffutils
  # fd
  # file
  # findutils
  # gawk
  # getopt
  # gettext
  # gnugrep
  # gnumake
  # gnupatch
  # gnused
  # gnutar
  # gzip
  # less
  # lsof
  # m4
  # pkg-config
  # tree
  # unzip
  # util-linux
  # wget
  # zip

  #### only use in docker
  # atuin
  # bat
  # bazelisk
  # bison
  # buildifier
  # exiftool
  # eza
  # flex
  # git-absorb
  # git-extras
  # git-filter-repo
  # git-lfs
  # glibcLocales
  # gnupg-minimal
  # ninja
  # openssh_gssapi
  # procs
  # protobuf_24
  # protobuf_25
  # protobuf_28
  # protobuf_3_8_0
  # protobuf_3_9_2
  # ruff
  # shfmt
  # starship
  # tzdata
  # zsh
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
  # silver-searcher

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

rm -rf tmp
curl https://raw.githubusercontent.com/curoky/static-binaries/refs/heads/master/tools/sbt >/tmp/sbt
chmod +x /tmp/sbt
for pkg in "${pkgs[@]}"; do
  /tmp/sbt install $pkg --prefix tmp/sbt &
done
/tmp/sbt install python311 --nolink --prefix tmp/sbt &
wait
cp /tmp/sbt tmp/sbt/bin/

# ln -s -r tmp/tools/bin/clang-format-18 tmp/tools/bin/clang-format

cp -f ../common/installer.sh tmp/sbt/

makeself --tar-format gnu --complevel 6 --tar-quietly --gzip --threads 16 tmp/sbt tmp/tools-installer.linux-x86_64.gzip.sh "Prebuilt Installer" ./installer.sh
makeself --tar-format gnu --complevel 16 --tar-quietly --zstd --threads 16 tmp/sbt tmp/tools-installer.linux-x86_64.zstd.sh "Prebuilt Installer" ./installer.sh
