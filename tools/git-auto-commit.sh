#!/usr/bin/env bash
export PATH=/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH

set -xeuo pipefail

cd $1
git add .
git pull
git commit -v -m "$(date --rfc-3339=seconds)" || echo ignore
git push
