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

export CONFIG_HOME=~/dotbox/config

for f in "$CONFIG_HOME"/zsh/lib/*.sh; do
  source "$f"
done

#=-> homebrew
if [[ -f $HOMEBREW_PREFIX/bin/brew ]]; then
  eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
fi

#=-> nix
default_plugins_path=$HOME/prebuilt/share/oh-my-zsh/plugins
custom_plugins_path=$HOME/prebuilt/share/oh-my-zsh/custom/plugins
source $default_plugins_path/extract/extract.plugin.zsh
source $custom_plugins_path/conda-zsh-completion/conda-zsh-completion.plugin.zsh
source $custom_plugins_path/starship/starship.plugin.zsh
source $custom_plugins_path/atuin/atuin.plugin.zsh
source $custom_plugins_path/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
source $custom_plugins_path/zsh-completions/zsh-completions.plugin.zsh
source $custom_plugins_path/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh

#=-> conda
# if [[ -f /app/conda/bin/conda ]]; then
#   eval "$(/app/conda/bin/conda shell.zsh hook 2>/dev/null)"
# fi
# if [[ -f /opt/homebrew/Caskroom/miniconda/base/bin/conda ]]; then
#   eval "$(/opt/homebrew/Caskroom/miniconda/base/bin/conda shell.zsh hook 2>/dev/null)"
# fi

#=-> mamba
# if [ -f "/app/conda/etc/profile.d/mamba.sh" ]; then
#   . "/app/conda/etc/profile.d/mamba.sh"
# fi

# TODO: remove -u
# why: why add -u to compinit?
# ref: https://stackoverflow.com/questions/13762280/zsh-compinit-insecure-directories
# for error:
#   zsh compinit: insecure directories, run compaudit for list.
#   Ignore insecure directories and continue [y] or abort compinit [n]?
# autoload -zU compinit && compinit -u
autoload -U compinit && compinit -u

# compdef _bb bb bbup bb4 bb4up bbcl bbclup

# TODO: remove follow
# zstyle ':completion:*' menu select
# unset zle_bracketed_paste

#-> (post) starship
# eval "$(starship init zsh)"

#-> (post) mcfly
# eval "$(mcfly init zsh)"

#-> (post) atuin
# eval "$(atuin init zsh --disable-up-arrow)"
