#!/usr/bin/env bash
set -xeuo pipefail

abspath=$(cd "$(dirname "$0")" && pwd)

target=$HOME/app/prebuilt
post_link=0

while getopts "t:p:" opt; do
  case "$opt" in
    t)
      target="$OPTARG"
      ;;
    p)
      post_link=1
      ;;
    \?)
      echo "Usage: $0 [-t target] [-p post link]"
      exit 1
      ;;
  esac
done

rm -rf $target
mkdir -p $target
cp -r $abspath/* $target

if [ ! -z "$post_link" ]; then
  if ! grep -q 'prebuilt/bin' ~/.bashrc; then
    echo 'export PATH=$HOME/app/prebuilt/bin:$PATH' >>~/.bashrc
  fi
  if ! grep -q 'prebuilt/bin' ~/.profile; then
    echo 'export PATH=$HOME/app/prebuilt/bin:$PATH' >>~/.profile
  fi
fi
