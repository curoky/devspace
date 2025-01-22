#!/usr/bin/env bash
# Copyright (c) 2018-2024 curoky(cccuroky@gmail.com).
#
# This file is part of dotbox.
# See https://github.com/curoky/dotbox for further info.
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

target=$HOME/prebuilt
arch=$(echo $(uname -s)_$(uname -m) | tr '[:upper:]' '[:lower:]') # linux_amd64/darwin_arm64
url=https://github.com/curoky/dotbox/releases/download/v1.0/prebuilt.${arch}.tar.gz

while getopts "t:a:u:" opt; do
  case "$opt" in
    t)
      target="$OPTARG"
      ;;
    a)
      arch="$OPTARG"
      url=https://github.com/curoky/dotbox/releases/download/v1.0/prebuilt.${arch}.tar.gz
      ;;
    u)
      url="$OPTARG"
      ;;
    \?)
      echo "Usage: $0 [-t target] [-a arch] [-u url]"
      exit 1
      ;;
  esac
done

rm -rf /tmp/prebuilt.tar.gz
curl -L $url -o /tmp/prebuilt.tar.gz
rm -rf $target
mkdir $target
tar -x --gunzip -f /tmp/prebuilt.tar.gz -C $target --strip-components=1

# sudo find ~/prebuilt/bin -type f -exec xattr -d com.apple.quarantine {} +
