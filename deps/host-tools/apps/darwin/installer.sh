#!/usr/bin/bash
set -xeuo pipefail

unzip -d tmp/tools/Library tmp/tools/downloads/Kap.zip
unzip -d tmp/tools/Library tmp/tools/downloads/KeepingYouAwake.zip
unzip -d tmp/tools/Library tmp/tools/downloads/istatmenus6.zip

hdiutil attach tmp/tools/downloads/OBS-Studio.dmg
hdiutil attach tmp/tools/downloads/Snipaste.dmg
hdiutil attach tmp/tools/downloads/IINA.dmg
hdiutil attach tmp/tools/downloads/keka.dmg

cp -r '/Volumes/OBS Studio 31.1.2 (Apple)/OBS.app' tmp/tools/Library
cp -r '/Volumes/Snipaste/Snipaste.app' tmp/tools/Library
cp -r '/Volumes/IINA/IINA.app' tmp/tools/Library
cp -r '/Volumes/Keka/Keka.app' tmp/tools/Library

hdiutil detach '/Volumes/Snipaste'
hdiutil detach '/Volumes/IINA'
hdiutil detach '/Volumes/Keka'
hdiutil detach '/Volumes/OBS Studio 31.1.2 (Apple)'
