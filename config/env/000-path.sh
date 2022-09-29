# Copyright 2021 curoky(cccuroky@gmail.com).
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
  "$HOME/.local/bin"
  "$HOME/dotbox/tools"

  "/opt/conda/envs/py3/bin"

  "/opt/homebrew/opt/coreutils/libexec/gnubin"
  "/opt/homebrew/opt/grep/libexec/gnubin"
  "/opt/homebrew/opt/findutils/libexec/gnubin"
  "/opt/homebrew/opt/gawk/libexec/gnubin"
  "/opt/homebrew/opt/unzip/bin"
  "/opt/homebrew/opt/gnu-sed/libexec/gnubin"
  "/opt/homebrew/opt/gnu-tar/libexec/gnubin"
  "/opt/homebrew/opt/gnu-indent/libexec/gnubin"
  "/opt/homebrew/opt/gnu-getopt/bin"
  "/opt/homebrew/opt/openssl@3/bin"

  "$BREW_PREFIX/bin"
  "$BREW_PREFIX/sbin"

  "$HOME/.npm-global/bin"

  "$HOME/go/bin"

  "$BREW_PREFIX/lib/ruby/gems/3.1.0/bin"
  "/nix/var/nix/profiles/default/lib/ruby/gems/2.7.0/bin"

  "/opt/vcpkg"

  # "/opt/conda/bin"

  "/opt/bundles/bin"

  "$HOME/.cargo/bin"
)
for p in "${ENV_PATHS[@]}"; do
  [[ -d $p ]] && export PATH=$p:$PATH
done

ENV_FPATHS=(
  # homebrew
  # "$BREW_PREFIX/share/zsh/functions" # already added by default
  "$BREW_PREFIX/share/zsh/site-functions"
  "$BREW_PREFIX/Homebrew/completions/zsh"
  # system
  "/usr/share/zsh/vendor-completions"
  # typer
  "$HOME/.zfunc"
  # nix
  "/nix/var/nix/profiles/default/share/zsh/site-functions/"
)
for p in "${ENV_FPATHS[@]}"; do
  [[ -d $p ]] && fpath=($p $fpath)
done

# https://docs.python.org/3/using/cmdline.html#environment-variables
ENV_PYPATHS=(
  # "$DOTS_PATH/lib"
)
for p in "${ENV_PYPATHS[@]}"; do
  [[ -d $p ]] && export PYTHONPATH=$p:$PYTHONPATH
done
