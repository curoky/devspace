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

#=-> oh-my-zsh
export ZSH=~/prebuilt/share/oh-my-zsh

DISABLE_AUTO_UPDATE=true
ZSH_DISABLE_COMPFIX=true
DISABLE_LS_COLORS=true # we use exa not ls
# ZSH_THEME="spaceship"

plugins=(
  # common-aliases
  conda-zsh-completion
  extract
  # fzf
  git
  starship
  atuin
  zsh-autosuggestions
  zsh-completions
  zsh-syntax-highlighting
  # systemadmin
  # direnv
  # docker
  # docker-compose
  # git-auto-fetch
  # golang
  # history
  # pip
  # z
  # zoxide
  # direnv
)

#=-> zsh history
# https://zsh.sourceforge.io/Doc/Release/Options.html
# setopt | grep hist
# export HISTORY_IGNORE="(?|??|???|????|* --help|* --version)"
# if [[ -d "$HOME/My Drive/CKYData/010-backup/shell-history" ]]; then
#   HISTFILE="$HOME/My Drive/CKYData/010-backup/shell-history/$MY_HOST_NAME.$(id -u).$DEVBOX_PROFILE.zsh_history"
# fi

# HISTSIZE=30000
# SAVEHIST=20000
# setopt EXTENDED_HISTORY
# setopt HIST_EXPIRE_DUPS_FIRST
# setopt HIST_IGNORE_DUPS
# setopt HIST_IGNORE_ALL_DUPS
# setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
# setopt HIST_BEEP
# setopt noextendedhistory
# setopt nosharehistory
