#!/usr/bin/env bash
set -xeuo pipefail

rm -rf tmp/
mkdir -p tmp/dotbox
curl -sSL https://github.com/curoky/dotbox/archive/refs/heads/dev.tar.gz | tar -x --gunzip -C tmp/dotbox --strip-components 1

cp installer.sh tmp/dotbox

makeself --complevel 6 --tar-quietly --gzip --threads 16 tmp/dotbox tmp/dotbox_installer.gzip.sh "Dotbox Installer" ./installer.sh
