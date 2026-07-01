#!/usr/bin/env bash
set -xeuo pipefail

abspath=$(cd "$(dirname "$0")" && pwd)

target=${1:-$HOME/app/sbt}

rm -rf $target
mkdir -p $target
cp -r $abspath/* $target

if ! grep -q 'app/sbt/bin' ~/.bashrc; then
  echo 'export PATH=$HOME/app/sbt/bin:$PATH' >>~/.bashrc
fi

if ! grep -q 'app/sbt/bin' ~/.profile; then
  echo 'export PATH=$HOME/app/sbt/bin:$PATH' >>~/.profile
fi
