#!/usr/bin/env bash
set -xeuo pipefail

abspath=$(cd "$(dirname "$0")" && pwd)

target=${1:-$HOME/app/sre-tools}

rm -rf $target
mkdir -p $target
cp -r $abspath/* $target

if ! grep -q 'app/sre-tools/bin' ~/.bashrc; then
  echo 'export PATH=$HOME/app/sre-tools/bin:$PATH' >>~/.bashrc
fi

if ! grep -q 'app/sre-tools/bin' ~/.profile; then
  echo 'export PATH=$HOME/app/sre-tools/bin:$PATH' >>~/.profile
fi
