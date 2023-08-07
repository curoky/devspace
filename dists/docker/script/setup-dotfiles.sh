#!/usr/bin/env bash
set -xeuo pipefail

git clone https://github.com/curoky/dotbox.git ~/dotbox

dotdrop install --cfg=~/dotbox/config.yaml --force --profile=devbox-userconf

if [[ "$(id -un)" == "root" ]]; then
  dotdrop install --cfg=~/dotbox/config.yaml --force --profile=devbox-sysconf
fi
