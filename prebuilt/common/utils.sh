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
  mkdir -p tmp/prebuilt/pkgs/${pkg}
  curl -sSL -o tmp/download/${pkg}.tar.gz https://github.com/curoky/prebuilt/releases/download/v1.0/${pkg}.${arch,,}.tar.gz
  tar -x --gunzip -f tmp/download/${pkg}.tar.gz -C tmp/prebuilt/pkgs/${pkg} --strip-components 1
}

function link_to_bin() {
  mkdir -p tmp/prebuilt/bin
  for dir in tmp/prebuilt/pkgs/*; do
    if [[ -d $dir/bin ]]; then
      if [[ ! -f $dir/skip_link ]]; then
        for file in $dir/bin/*; do
          if [[ -L $file ]] || [[ -f $file ]]; then
            if [[ -f $PWD/tmp/prebuilt/bin/$(basename $file) ]]; then
              rm $PWD/tmp/prebuilt/bin/$(basename $file)
            fi
            ln -s -r $file $PWD/tmp/prebuilt/bin/
          fi
        done
      fi
    fi
  done
  # find tmp/prebuilt/pkgs/*/bin -type f -exec ln -s -r {} $PWD/tmp/prebuilt/bin/ \;
  # find tmp/prebuilt/pkgs/*/bin -type l -exec ln -s -r {} $PWD/tmp/prebuilt/bin/ \;
}

function link_zsh_comp() {
  rm -rf tmp/prebuilt/share/zsh/site-functions/
  mkdir -p tmp/prebuilt/share/zsh/site-functions/
  find tmp/prebuilt/pkgs -type d -path "*/zsh/site-functions" | while read -r dir; do
    for file in $dir/*; do
      ln -s -r $file tmp/prebuilt/share/zsh/site-functions/
    done
  done
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
  mv tmp/prebuilt/pkgs/curl/bin/curl tmp/prebuilt/pkgs/curl/bin/dot-curl-wrapped
  cp wrapper/curl tmp/prebuilt/pkgs/curl/bin/curl

  mv tmp/prebuilt/pkgs/wget/bin/wget tmp/prebuilt/pkgs/wget/bin/dot-wget-wrapped
  cp wrapper/wget tmp/prebuilt/pkgs/wget/bin/wget

  mv tmp/prebuilt/pkgs/file/bin/file tmp/prebuilt/pkgs/file/bin/dot-file-wrapped
  cp wrapper/file tmp/prebuilt/pkgs/file/bin/file

  mv tmp/prebuilt/pkgs/vim/bin/vim tmp/prebuilt/pkgs/vim/bin/dot-vim-wrapped
  cp wrapper/vim tmp/prebuilt/pkgs/vim/bin/vim

  mv tmp/prebuilt/pkgs/zsh/bin/zsh tmp/prebuilt/pkgs/zsh/bin/dot-zsh-wrapped
  cp wrapper/zsh tmp/prebuilt/pkgs/zsh/bin/zsh

  mv tmp/prebuilt/pkgs/openssh_gssapi/bin/scp tmp/prebuilt/pkgs/openssh_gssapi/bin/dot-scp-wrapped
  cp wrapper/scp tmp/prebuilt/pkgs/openssh_gssapi/bin/scp

  cp \
    wrapper/dool \
    wrapper/git-filter-repo \
    wrapper/netron \
    tmp/prebuilt/bin
}

function add_dotbox() {
  mkdir -p tmp/prebuilt/dotbox
  curl -sSL https://github.com/curoky/dotbox/archive/refs/heads/dev.tar.gz | tar -x --gunzip -C tmp/prebuilt/dotbox --strip-components 1
}
