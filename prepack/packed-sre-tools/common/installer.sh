#!/usr/bin/env bash
set -xeuo pipefail

abspath=$(cd "$(dirname "$0")" && pwd)

target=${1:-$HOME/app/prebuilt}

rm -rf $target
mkdir -p $target
cp -r $abspath/* $target

if ! grep -q 'prebuilt/bin' ~/.bashrc; then
  echo 'export PATH=$HOME/app/prebuilt/bin:$PATH' >>~/.bashrc
fi

if ! grep -q 'prebuilt/bin' ~/.profile; then
  echo 'export PATH=$HOME/app/prebuilt/bin:$PATH' >>~/.profile
fi
