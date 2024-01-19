#!/usr/bin/env bash
set -xeuo pipefail

curl -sSL -o libtinfo5_6.4-2_amd64.deb http://security.ubuntu.com/ubuntu/pool/universe/n/ncurses/libtinfo5_6.4-2_amd64.deb

dpkg -i libtinfo5_6.4-2_amd64.deb

rm -rf libtinfo5_6.4-2_amd64.deb
