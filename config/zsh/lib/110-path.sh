# Copyright (c) 2018-2023 curoky(cccuroky@gmail.com).
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

ENV_PATHS=(
  "$BREW_PREFIX/opt/coreutils/libexec/gnubin"
  "$BREW_PREFIX/opt/findutils/libexec/gnubin"
  "$BREW_PREFIX/opt/gawk/libexec/gnubin"
  "$BREW_PREFIX/opt/gnu-getopt/bin"
  "$BREW_PREFIX/opt/gnu-indent/libexec/gnubin"
  "$BREW_PREFIX/opt/gnu-sed/libexec/gnubin"
  "$BREW_PREFIX/opt/gnu-tar/libexec/gnubin"
  "$BREW_PREFIX/opt/grep/libexec/gnubin"
  "$BREW_PREFIX/opt/openssl@3/bin"
  "$BREW_PREFIX/opt/unzip/bin"
  "$BREW_PREFIX/opt/ruby/bin"

  "/opt/conda/envs/default/bin"
)
for p in "${ENV_PATHS[@]}"; do
  [[ -d $p ]] && export PATH=$p:$PATH
done

ENV_PATHS=(
  "/nix/var/nix/profiles/default/lib/ruby/gems/2.7.0/bin"
  "/opt/vcpkg"
  "$BREW_PREFIX/lib/ruby/gems/3.1.0/bin"
  # "$HOME/.cargo/bin" # already source in ~/.zshenv
  "$HOME/.local/bin"
  "$HOME/.npm-global/bin"
  "$HOME/dotbox/tools"
  "$HOME/go/bin"
  # "/nix/var/nix/profiles/cuda11_8/bin"
)
for p in "${ENV_PATHS[@]}"; do
  [[ -d $p ]] && export PATH=$PATH:$p
done
