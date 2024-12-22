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

ENV_PATHS=(
  "$HOMEBREW_PREFIX/opt/gawk/libexec/gnubin"
  "$HOMEBREW_PREFIX/opt/gnu-indent/libexec/gnubin"
  "$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin"
  "$HOMEBREW_PREFIX/opt/ruby/bin"
  "$HOME/prebuilt/bin"
  "/nix/var/nix/profiles/default/bin"
)
for p in "${ENV_PATHS[@]}"; do
  [[ -d $p ]] && export PATH=$p:$PATH
done

ENV_PATHS=(
  "$HOME/.local/bin"
  "$HOME/.nix-profile/bin"
  "/app/pipx/bin"
  "/app/conda/condabin"

  # "/app/prebuilt/extra/bin"
  # "$HOME/.npm-global/bin"
  "$HOME/dotbox/tools"
  # "$HOME/go/bin"
  # "/nix/var/nix/profiles/default/lib/ruby/gems/2.7.0/bin"
  # "$HOMEBREW_PREFIX/lib/ruby/gems/3.1.0/bin"
  # "$HOME/.cargo/bin" # already source in ~/.zshenv
  # /nix/var/nix/profiles/gcc13/bin
)
for p in "${ENV_PATHS[@]}"; do
  [[ -d $p ]] && export PATH=$PATH:$p
done

ENV_FPATHS=(
  # homebrew
  # "$HOMEBREW_PREFIX/share/zsh/functions" # already added by default
  # "$HOMEBREW_PREFIX/share/zsh/site-functions"
  "$HOMEBREW_PREFIX/Homebrew/completions/zsh"
  # system
  # "/usr/share/zsh/vendor-completions"
  # typer
  # "$HOME/.zfunc"

  "$HOME/prebuilt/pkgs/zsh-bundle/share/zsh/site-functions"
  # "$HOME/prebuilt/share/zsh/zsh-functions"
)

for p in "${ENV_FPATHS[@]}"; do
  [[ -d $p ]] && fpath=($p $fpath)
done

ENV_PATHS=(
  # "$WORKSPACE/thriftoy"
  # "/data/share/thriftoy"
)

for p in "${ENV_PATHS[@]}"; do
  [[ -d $p ]] && export PYTHONPATH=$p:$PYTHONPATH
done
