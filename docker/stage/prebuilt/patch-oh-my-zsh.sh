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
