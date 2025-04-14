#!/usr/bin/env bash
set -xeuo pipefail

abspath=$(cd "$(dirname "$0")" && pwd)

target=$HOME/app/dotbox
link=0
link_name=host-linux

while getopts "t:l:n" opt; do
  case "$opt" in
    t)
      target="$OPTARG"
      ;;
    l)
      link=1
      ;;
    n)
      link_name="$OPTARG"
      ;;
    \?)
      echo "Usage: $0 [-t target] [-l link] [-n link_name]"
      exit 1
      ;;
  esac
done

rm -rf $target
mkdir -p $target
cp -r $abspath/* $target

if [ $link -eq 1 ]; then
  rm -f $HOME/dotbox
  ln -s $target $HOME/dotbox
  $HOME/dotbox/config/setup.sh $link_name $HOME/dotbox/config
fi
