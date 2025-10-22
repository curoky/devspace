#!/usr/bin/env bash

set -xeuo pipefail

rm -rf ~/Downloads/Apps
mkdir ~/Downloads/Apps

curl -sSL -o ~/Downloads/Apps/arc.dmg 'https://releases.arc.net/release/Arc-latest.dmg' &
curl -sSL -o ~/Downloads/Apps/chrome.dmg 'https://dl.google.com/chrome/mac/universal/stable/GGRO/googlechrome.dmg' &
curl -sSL -o ~/Downloads/Apps/vscode.zip 'https://code.visualstudio.com/sha/download?build=stable&os=darwin-arm64' &
curl -sSL -o ~/Downloads/Apps/notion.dmg 'https://www.notion.com/desktop/mac-apple-silicon/download?from=marketing&pathname=%2Fdesktop&tid=1dfa4677bb9c45cdbd92e79a40a1b21b' &
curl -sSL -o ~/Downloads/Apps/notion-calendar.dmg 'https://www.notion.com/calendar/desktop/mac/download?from=marketing&pathname=%2Fproduct%2Fcalendar%2Fdownload&tid=1dfa4677bb9c45cdbd92e79a40a1b21b' &
curl -sSL -o ~/Downloads/Apps/warp.dmg 'https://app.warp.dev/download?package=dmg' &
curl -sSL -o ~/Downloads/Apps/telegram.dmg 'https://telegram.org/dl/desktop/mac' &
curl -sSL -o ~/Downloads/Apps/firefox.dmg 'https://download.mozilla.org/?product=firefox-latest-ssl&os=osx&lang=en-US' &

# # https://github.com/wulkano/Kap/releases
# curl -sSL -o ~/Downloads/Apps/Kap.zip 'https://github.com/wulkano/Kap/releases/download/v3.6.0/Kap-3.6.0-arm64-mac.zip' &

# # https://github.com/newmarcel/KeepingYouAwake/releases
# curl -sSL -o ~/Downloads/Apps/KeepingYouAwake.zip 'https://github.com/newmarcel/KeepingYouAwake/releases/download/1.6.7/KeepingYouAwake-1.6.7.zip' &

# # https://download.bjango.com/istatmenus6/
# curl -sSL -o ~/Downloads/Apps/istatmenus6.zip 'https://cdn.istatmenus.app/files/istatmenus6/istatmenus6.73.1.zip' &

# # https://github.com/obsproject/obs-studio/releases
# curl -sSL -o ~/Downloads/Apps/OBS-Studio.dmg 'https://github.com/obsproject/obs-studio/releases/download/31.1.2/OBS-Studio-31.1.2-macOS-Apple.dmg' &

# # https://zh.snipaste.com/download.html
# curl -sSL -o ~/Downloads/Apps/Snipaste.dmg 'https://download.snipaste.com/archives/Snipaste-2.10.8.dmg' &

# # https://github.com/iina/iina/releases
# curl -sSL -o ~/Downloads/Apps/IINA.dmg 'https://github.com/iina/iina/releases/download/v1.3.5/IINA.v1.3.5.dmg' &

# # https://github.com/aonez/Keka/releases
# curl -sSL -o ~/Downloads/Apps/Keka.dmg 'https://github.com/aonez/Keka/releases/download/v1.5.2/Keka-1.5.2.dmg' &

wait
