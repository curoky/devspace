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
  "$HOMEBREW_PREFIX/opt/ruby/bin"
  "$HOME/app/prebuilt/bin"
  "/nix/var/nix/profiles/default/bin"
)
for p in "${ENV_PATHS[@]}"; do
  [[ -d $p ]] && export PATH=$p:$PATH
done

ENV_PATHS=(
  "$HOME/.local/bin"
  "$HOME/.nix-profile/bin"

  "$HOME/app/conda/condabin"
  "$HOME/app/pipx/bin"

  # "$HOME/.npm-global/bin"
  "$HOME/dotbox/tools"
  # "/nix/var/nix/profiles/default/lib/ruby/gems/2.7.0/bin"
  # "$HOMEBREW_PREFIX/lib/ruby/gems/3.1.0/bin"
  # "$HOME/.cargo/bin" # already source in ~/.zshenv
)
for p in "${ENV_PATHS[@]}"; do
  [[ -d $p ]] && export PATH=$PATH:$p
done

ENV_FPATHS=(
  "$HOMEBREW_PREFIX/completions/zsh"

  # typer
  # "$HOME/.zfunc"

  "$HOME/app/prebuilt/share/zsh/site-functions"
  "$HOME/app/prebuilt/pkgs/zsh-bundle/share/oh-my-zsh/custom/plugins/zsh-completions/src"
  "$HOME/app/prebuilt/pkgs/zsh-bundle/share/oh-my-zsh/custom/plugins/conda-zsh-completion"
)

for p in "${ENV_FPATHS[@]}"; do
  [[ -d $p ]] && fpath=($p $fpath)
done

ENV_PATHS=(
)

for p in "${ENV_PATHS[@]}"; do
  [[ -d $p ]] && export PYTHONPATH=$p:$PYTHONPATH
done
