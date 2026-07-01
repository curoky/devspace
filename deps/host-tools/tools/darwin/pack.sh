#!/usr/bin/env bash
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
  lefthook

  # lxgw-wenkai
  # fira-code
  # nerd-fonts.fira-code
  # nerd-fonts.ubuntu-mono

  ##### unneeded
  # vim
  # zsh
  # aria2
  # gost

  # ruff need link jemalloc
)

rm -rf tmp
curl https://raw.githubusercontent.com/curoky/static-binaries/refs/heads/master/tools/sbt >/tmp/sbt
chmod +x /tmp/sbt
for pkg in "${pkgs[@]}"; do
  /tmp/sbt install $pkg --arch darwin-arm64 --prefix tmp/sbt &
done
wait
cp /tmp/sbt tmp/sbt/bin/

cp -f ../common/installer.sh tmp/sbt/

makeself --tar-format gnu --complevel 6 --tar-quietly --gzip --threads 16 tmp/sbt tmp/tools-installer.darwin-arm64.gzip.sh "Prebuilt Installer" ./installer.sh
makeself --tar-format gnu --complevel 16 --tar-quietly --zstd --threads 16 tmp/sbt tmp/tools-installer.darwin-arm64.zstd.sh "Prebuilt Installer" ./installer.sh
