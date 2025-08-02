#!/usr/bin/env bash
# Copyright (c) 2018-2025 curoky(cccuroky@gmail.com).
#
# This file is part of devspace.
# See https://github.com/curoky/devspace for further info.
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
set -xeuo pipefail

rm -rf tmp && mkdir tmp

mkdir -p tmp/apps/fonts

curl -sSL -o tmp/apps/fonts/nerd-fonts.fira-code.tar.gz https://github.com/curoky/static-binaries/releases/download/v1.0/nerd-fonts.fira-code.darwin-arm64.tar.gz &
curl -sSL -o tmp/apps/fonts/nerd-fonts.ubuntu-mono.tar.gz https://github.com/curoky/static-binaries/releases/download/v1.0/nerd-fonts.ubuntu-mono.darwin-arm64.tar.gz &
curl -sSL -o tmp/apps/fonts/lxgw-wenkai.tar.gz https://github.com/curoky/static-binaries/releases/download/v1.0/lxgw-wenkai.darwin-arm64.tar.gz &

# https://github.com/wulkano/Kap/releases
# https://github.com/wulkano/Kap/releases/download/v3.6.0/Kap-3.6.0-arm64-mac.zip

# https://github.com/iina/iina/releases
# https://github.com/iina/iina/releases/download/v1.3.5/IINA.v1.3.5.dmg

# https://zh.snipaste.com/download.html
# https://download.snipaste.com/archives/Snipaste-2.10.8.dmg

# https://github.com/newmarcel/KeepingYouAwake/releases
# https://github.com/newmarcel/KeepingYouAwake/releases/download/1.6.7/KeepingYouAwake-1.6.7.zip

# https://download.bjango.com/istatmenus6/
# https://cdn.istatmenus.app/files/istatmenus6/istatmenus6.73.1.zip

# https://github.com/obsproject/obs-studio/releases
# https://cdn-fastly.obsproject.com/downloads/obs-studio-31.1.2-macos-apple.dmg
# https://github.com/obsproject/obs-studio/releases/download/31.1.2/OBS-Studio-31.1.2-macOS-Apple.dmg

# https://github.com/aonez/Keka/releases
# https://github.com/aonez/Keka/releases/download/v1.5.2/Keka-1.5.2.dmg

curl -sSL -o tmp/apps/Kap.zip https://github.com/wulkano/Kap/releases/download/v3.6.0/Kap-3.6.0-arm64-mac.zip &
curl -sSL -o tmp/apps/KeepingYouAwake.zip https://github.com/newmarcel/KeepingYouAwake/releases/download/1.6.7/KeepingYouAwake-1.6.7.zip &
curl -sSL -o tmp/apps/istatmenus6.zip https://cdn.istatmenus.app/files/istatmenus6/istatmenus6.73.1.zip &
# curl -sSL -o tmp/apps/OBS-Studio.dmg https://github.com/obsproject/obs-studio/releases/download/31.1.2/OBS-Studio-31.1.2-macOS-Apple.dmg &
curl -sSL -o tmp/apps/Snipaste.dmg https://download.snipaste.com/archives/Snipaste-2.10.8.dmg &
curl -sSL -o tmp/apps/IINA.dmg https://github.com/iina/iina/releases/download/v1.3.5/IINA.v1.3.5.dmg &
curl -sSL -o tmp/apps/Keka.dmg https://github.com/aonez/Keka/releases/download/v1.5.2/Keka-1.5.2.dmg &
wait

cp -f ./installer.sh tmp/apps

# makeself --tar-format gnu --complevel 6 --tar-quietly --gzip --threads 16 tmp/apps tmp/apps-installer.darwin-arm64.gzip.sh "Apps" ./installer.sh
# makeself --tar-format gnu --complevel 16 --tar-quietly --zstd --threads 16 tmp/apps tmp/apps-installer.darwin-arm64.zstd.sh "Apps" ./installer.sh
