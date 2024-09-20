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

prefix=${1:-/output}

sed -i 's$pluginpath = \[$pluginpath = \[os\.path\.dirname\(__file__\)+"/\.\./share/dool/",$g' \
  $prefix/extra/bin/dool
sed -i '1s|.*|#!/usr/bin/env bash|' $prefix/bin/lsb_release
sed -i -e 's|/nix/store/[a-z0-9\._-]*/bin/||g' \
  $prefix/bin/lsb_release

# find all plain text file in /usr/bin, and do sed
for f in $(find $prefix/bin -type f); do
  if file "$f" | grep -q 'text'; then
    sed -i -e 's|/nix/store/[a-z0-9\._-]*/bin/||g' "$f"
  fi
done

for f in $(find $prefix -type f); do
  if file "$f" | grep -q 'text'; then
    sed -i -e 's|/nix/store/[a-z0-9\._-]*/bin/||g' "$f"
  elif file "$f" | grep -q 'ELF'; then
    strip --strip-unneeded "$f"
  fi
done

rm -rf $prefix/bin/xxd
cp -L /nix/var/nix/profiles/default/bin/xxd $prefix/bin/xxd

ln -s -r $prefix/bin/bazelisk $prefix/bin/bazel
ln -s -r $prefix/bin/clang-format-18 $prefix/bin/clang-format
mv $prefix/bin/.bat-wrapped $prefix/bin/bat
mv $prefix/bin/.gzip-wrapped $prefix/bin/gzip

mv $prefix/share/zsh/5.9/functions/* $prefix/share/zsh/site-functions/

find $prefix -name "*.a" -delete
find $prefix -name "*.pyc" -delete
rm -rf \
  $prefix/extra/share/vim/vim91/doc \
  $prefix/bin/ruff_dev \
  $prefix/bin/red_knot \
  $prefix/lib/locale/locale-archive \
  $prefix/lib/cmake \
  $prefix/nix-support \
  $prefix/extra/nix-support \
  $prefix/test \
  $prefix/.github \
  $prefix/.gitignore \
  $prefix/*.yaml \
  $prefix/*.png
