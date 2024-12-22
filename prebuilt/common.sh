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

function download_pkg() {
  pkg=$1
  arch=$(uname -s)_$(uname -m)
  mkdir -p tmp/download
  mkdir -p tmp/prebuilt/pkgs/${pkg}
  curl -sSL -o tmp/download/${pkg}.tar.gz https://github.com/curoky/prebuilt/releases/download/v1.0/${pkg}.${arch,,}.tar.gz
  tar -x --gunzip -f tmp/download/${pkg}.tar.gz -C tmp/prebuilt/pkgs/${pkg} --strip-components 1
}

function link_to_bin() {
  mkdir -p tmp/prebuilt/bin
  find tmp/prebuilt/pkgs/*/bin -type f -exec ln -s -r {} $PWD/tmp/prebuilt/bin/ \;
}

function strip_bin() {
  chmod -R +w tmp/prebuilt/
  find tmp/prebuilt/pkgs/*/bin -executable -type f | while read -r file; do
    if file "$file" | grep -q 'ELF'; then
      strip --strip-unneeded "$file"
    fi
  done
}

function remove_unneeded() {
  find tmp/prebuilt/ -name "*.a" -delete
  find tmp/prebuilt/ -name "*.pyc" -delete

  # remove ld from binutils
  # /app/prebuilt/extra/bin/ld.gold: error: /usr/lib/gcc/x86_64-linux-gnu/8/liblto_plugin.so: could not load plugin library: Dynamic loading not supported
  rm -rf tmp/prebuilt/bin/ld tmp/prebuilt/bin/ld.bfd tmp/prebuilt/bin/ld.gold
}

function rename_wrapped() {
  find tmp/prebuilt/pkgs -type f -name ".*-wrapped" | while read -r file; do
    dir=$(dirname "$file")
    new_name=$(basename "$file" | sed -e 's/-wrapped//g' -e 's/^.//')
    mv "$file" "$dir/$new_name"
  done
}

function copy_wrapper() {
  cp --remove-destination wrapper/* tmp/prebuilt/bin/
}

function add_dotbox() {
  mkdir -p tmp/prebuilt/dotbox
  curl -sSL https://github.com/curoky/dotbox/archive/refs/heads/dev.tar.gz | tar -xv --gunzip -C tmp/prebuilt/dotbox --strip-components 1
}
