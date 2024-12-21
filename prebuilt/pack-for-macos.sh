#!/usr/bin/env bash
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

rename_wrapped
remove_unneeded
link_bin

ln -s -r tmp/prebuilt/bin/vim tmp/prebuilt/bin/vi

tar -czvf tmp/prebuilt.darwin_arm64.tar.gz tmp/prebuilt
