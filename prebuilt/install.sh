#!/usr/bin/env bash

set -xeuo pipefail

arch=darwin_arm64
arch=linux_amd64

rm -rf /tmp/prebuilt.tar.gz
curl -SL https://github.com/curoky/dotbox/releases/download/v1.0/prebuilt.${arch}.tar.gz -o /tmp/prebuilt.tar.gz
rm -rf ~/prebuilt2
mkdir ~/prebuilt2
tar -xzf /tmp/prebuilt.tar.gz -C ~/prebuilt2 --strip-components=1

# sudo find ~/prebuilt/bin -type f -exec xattr -d com.apple.quarantine {} +
