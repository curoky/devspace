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
  arch=${2:-$(uname -s)-$(uname -m)}
  # arch=$(echo $(uname -s)-$(uname -m) | tr '[:upper:]' '[:lower:]')
  mkdir -p tmp/download
  mkdir -p tmp/sre-tools/pkgs/${pkg}
  curl -sSL -o tmp/download/${pkg}.tar.gz https://github.com/curoky/prebuilt/releases/download/v1.0/${pkg}.${arch,,}.tar.gz
  tar -x --gunzip -f tmp/download/${pkg}.tar.gz -C tmp/sre-tools/pkgs/${pkg} --strip-components 1
}

function link_to_bin() {
  mkdir -p tmp/sre-tools/bin
  for dir in tmp/sre-tools/pkgs/*; do
    if [[ -d $dir/bin ]]; then
      if [[ ! -f $dir/skip_link ]]; then
        for file in $dir/bin/*; do
          if [[ -L $file ]] || [[ -f $file ]]; then
            if [[ -f $PWD/tmp/sre-tools/bin/$(basename $file) ]]; then
              rm $PWD/tmp/sre-tools/bin/$(basename $file)
            fi
            ln -s -r $file $PWD/tmp/sre-tools/bin/
          fi
        done
      fi
    fi
  done
  # find tmp/sre-tools/pkgs/*/bin -type f -exec ln -s -r {} $PWD/tmp/sre-tools/bin/ \;
  # find tmp/sre-tools/pkgs/*/bin -type l -exec ln -s -r {} $PWD/tmp/sre-tools/bin/ \;
}

function link_zsh_site_funtions() {
  rm -rf tmp/sre-tools/share/zsh/site-functions/
  mkdir -p tmp/sre-tools/share/zsh/site-functions/
  find tmp/sre-tools/pkgs -type d -path "*/zsh/site-functions" | while read -r dir; do
    for file in $dir/*; do
      ln -s -r $file tmp/sre-tools/share/zsh/site-functions/
    done
  done
}

function strip_binary() {
  chmod -R +w tmp/sre-tools/
  find tmp/sre-tools/pkgs/*/bin -executable -type f | while read -r file; do
    if file "$file" | grep -q 'ELF'; then
      strip --strip-unneeded "$file"
    fi
  done
}

function remove_unneeded() {
  find tmp/sre-tools/ -name "*.a" -delete
  find tmp/sre-tools/ -name "*.pyc" -delete

  # remove ld from binutils
  # ~/app/prebuilt/extra/bin/ld.gold: error: /usr/lib/gcc/x86_64-linux-gnu/8/liblto_plugin.so: could not load plugin library: Dynamic loading not supported
  rm -rf tmp/sre-tools/bin/ld tmp/sre-tools/bin/ld.bfd tmp/sre-tools/bin/ld.gold
}

function rename_wrapped() {
  find tmp/sre-tools/pkgs -type f -name ".*-wrapped" | while read -r file; do
    dir=$(dirname "$file")
    new_name=$(basename "$file" | sed -e 's/-wrapped//g' -e 's/^.//')
    mv "$file" "$dir/$new_name"
  done
}

function remove_invalid_link() {
  find tmp/sre-tools -type l -exec test ! -e {} \; -print | while read -r file; do
    echo "remove invalid link: $file"
    rm -rf "$file"
  done
}

# function copy_wrapper() {
#   cp \
#     wrapper/dool \
#     wrapper/git-filter-repo \
#     wrapper/netron \
#     tmp/sre-tools/bin
# }

# function add_dotbox() {
#   mkdir -p tmp/sre-tools/dotbox
#   curl -sSL https://github.com/curoky/dotbox/archive/refs/heads/dev.tar.gz | tar -x --gunzip -C tmp/sre-tools/dotbox --strip-components 1
# }
