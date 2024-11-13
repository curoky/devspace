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

# sed -i 's$pluginpath = \[$pluginpath = \[os\.path\.dirname\(__file__\)+"/\.\./share/dool/",$g' \
#   $prefix/py311/bin/dool
# sed -i '1s|.*|#!/usr/bin/env bash|' $prefix/bin/lsb_release
# sed -i -e 's|/nix/store/[a-z0-9\._-]*/bin/||g' \
#   $prefix/bin/lsb_release

for f in $(find $prefix -type f); do
  if file "$f" | grep -q 'text'; then
    sed -i -e 's|#\!\s*/nix/store/[a-z0-9\._-]*/bin/|#\! /usr/bin/env |g' "$f"
    sed -i -e 's|/nix/store/[a-z0-9\._-]*/bin/||g' "$f"
  elif file "$f" | grep -q 'ELF'; then
    strip --strip-unneeded "$f"
  fi
done

ln -s -r $prefix/extra/bin/bazelisk $prefix/extra/bin/bazel
ln -s -r $prefix/bin/clang-format-18 $prefix/bin/clang-format
ln -s -r $prefix/bin/vim $prefix/bin/vi
mv $prefix/bin/.bat-wrapped $prefix/bin/bat
mv $prefix/bin/.gzip-wrapped $prefix/bin/gzip
# mv $prefix/bin/git $prefix/bin/.git-wrapped
mv $prefix/bin/curl $prefix/bin/.curl-wrapped
mv $prefix/bin/wget $prefix/bin/.wget-wrapped
mv $prefix/bin/scp $prefix/bin/.scp-wrapped

mkdir -p $prefix/share/oh-my-zsh/custom/plugins/starship
$prefix/bin/starship init zsh >$prefix/share/oh-my-zsh/custom/plugins/starship/starship.plugin.zsh
$prefix/bin/starship completions zsh >$prefix/share/oh-my-zsh/custom/plugins/starship/_starship
mkdir -p $prefix/share/oh-my-zsh/custom/plugins/atuin
$prefix/bin/atuin init zsh --disable-up-arrow >$prefix/share/oh-my-zsh/custom/plugins/atuin/atuin.plugin.zsh
$prefix/bin/atuin gen-completions --shell zsh >$prefix/share/oh-my-zsh/custom/plugins/atuin/_atuin
mkdir -p $prefix/share/oh-my-zsh/custom/plugins/fzf
cp $prefix/share/fzf/completion.zsh $prefix/share/oh-my-zsh/custom/plugins/fzf/_fzf_completion
cp $prefix/share/fzf/key-bindings.zsh $prefix/share/oh-my-zsh/custom/plugins/fzf/key-bindings.zsh
cp $prefix/share/oh-my-zsh/custom/plugins/conda-zsh-completion/_conda $prefix/share/zsh/site-functions

find $prefix -name "*.a" -delete
find $prefix -name "*.pyc" -delete
rm -rf \
  $prefix/inner/share/vim/vim91/doc \
  $prefix/bin/ruff_dev \
  $prefix/bin/red_knot

# remove ld from binutils
# /app/prebuilt/extra/bin/ld.gold: error: /usr/lib/gcc/x86_64-linux-gnu/8/liblto_plugin.so: could not load plugin library: Dynamic loading not supported
rm -rf $prefix/extra/bin/ld $prefix/extra/bin/ld.bfd $prefix/extra/bin/ld.gold
