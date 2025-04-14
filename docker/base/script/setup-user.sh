#!/usr/bin/env bash
set -xeuo pipefail

# remove user ubuntu
userdel ubuntu -r || echo "ignore userdel failed"

# update user root
echo "root:123456" | chpasswd
# chsh -s /home/x/app/prebuilt/pkgs/zsh/bin/zsh

# add user x
useradd --create-home --uid 5230 --user-group x # --shell /home/x/app/prebuilt/pkgs/zsh/bin/zsh
echo "x:123456" | chpasswd
usermod -aG sudo x
echo "x ALL=(ALL:ALL) NOPASSWD:ALL" >>/etc/sudoers.d/nopasswd_user
