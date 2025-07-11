#!/usr/bin/env bash
# Copyright (c) 2018-2025 curoky(cccuroky@gmail.com).
#
# This file is part of devspace.
# See https://github.com/curoky/devspace for further info.
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

abspath=$(cd "$(dirname "$0")" && pwd)

target=$HOME/app/devspace
link=0
link_name=host-linux

while getopts "t:ln:" opt; do
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
      echo "Usage: $0 [-t target] [-l] [-n link_name]"
      exit 1
      ;;
  esac
done

rm -rf $target
mkdir -p $target
cp -r $abspath/* $target

if [ $link -eq 1 ]; then
  rm -f $HOME/devspace
  ln -s $target $HOME/devspace
  $HOME/devspace/dotfiles/setup.sh $link_name $HOME/devspace/dotfiles
fi
