#!/usr/bin/env bash
set -xeuo pipefail

wget https://github.com/curoky/dotbox/releases/download/v1.0.0/prebuilt.tar.zip -O /tmp/prebuilt.tar.zip
unzip -o /tmp/prebuilt.tar.zip -d /tmp/prebuilt.tar
mkdir ~/prebuilt
tar -xf /tmp/prebuilt.tar/output.tar -C ~/prebuilt --strip-components=1
echo "export PATH=$HOME/prebuilt/bin:$PATH" >>~/.bashrc
echo "export PATH=$HOME/prebuilt/bin:$PATH" >>~/.profile
