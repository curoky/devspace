#!/usr/bin/env bash

set -xeuo pipefail

rm -rf downloads
mkdir downloads

curl -sSL -o downloads/arc.dmg 'https://releases.arc.net/release/Arc-latest.dmg' &
curl -sSL -o downloads/chrome.dmg 'https://dl.google.com/chrome/mac/universal/stable/GGRO/googlechrome.dmg' &
curl -sSL -o downloads/vscode.zip 'https://code.visualstudio.com/sha/download?build=stable&os=darwin-arm64' &
curl -sSL -o downloads/notion.dmg 'https://www.notion.com/desktop/mac-apple-silicon/download?from=marketing&pathname=%2Fdesktop&tid=1dfa4677bb9c45cdbd92e79a40a1b21b' &
curl -sSL -o downloads/notion-calendar.dmg 'https://www.notion.com/calendar/desktop/mac/download?from=marketing&pathname=%2Fproduct%2Fcalendar%2Fdownload&tid=1dfa4677bb9c45cdbd92e79a40a1b21b' &
curl -sSL -o downloads/warp.dmg 'https://app.warp.dev/download?package=dmg' &
curl -sSL -o downloads/telegram.dmg 'https://telegram.org/dl/desktop/mac' &
curl -sSL -o downloads/firefox.dmg 'https://download.mozilla.org/?product=firefox-latest-ssl&os=osx&lang=en-US' &

# https://github.com/wulkano/Kap/releases
curl -sSL -o downloads/Kap.zip 'https://github.com/wulkano/Kap/releases/download/v3.6.0/Kap-3.6.0-arm64-mac.zip' &

# https://github.com/newmarcel/KeepingYouAwake/releases
curl -sSL -o downloads/KeepingYouAwake.zip 'https://github.com/newmarcel/KeepingYouAwake/releases/download/1.6.7/KeepingYouAwake-1.6.7.zip' &

# https://download.bjango.com/istatmenus6/
curl -sSL -o downloads/istatmenus6.zip 'https://cdn.istatmenus.app/files/istatmenus6/istatmenus6.73.1.zip' &

# https://github.com/obsproject/obs-studio/releases
curl -sSL -o downloads/OBS-Studio.dmg 'https://github.com/obsproject/obs-studio/releases/download/31.1.2/OBS-Studio-31.1.2-macOS-Apple.dmg' &

# https://zh.snipaste.com/download.html
curl -sSL -o downloads/Snipaste.dmg 'https://download.snipaste.com/archives/Snipaste-2.10.8.dmg' &

# https://github.com/iina/iina/releases
curl -sSL -o downloads/IINA.dmg 'https://github.com/iina/iina/releases/download/v1.3.5/IINA.v1.3.5.dmg' &

# https://github.com/aonez/Keka/releases
curl -sSL -o downloads/Keka.dmg 'https://github.com/aonez/Keka/releases/download/v1.5.2/Keka-1.5.2.dmg' &

wait
