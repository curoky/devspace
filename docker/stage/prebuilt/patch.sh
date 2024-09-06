#!/usr/bin/env bash
set -xeuo pipefail

sed -i 's$pluginpath = \[$pluginpath = \[os\.path\.dirname\(__file__\)+"/\.\./share/dool/",$g' \
  /output/extra/bin/dool
sed -i '1s|.*|#!/usr/bin/env bash|' /output/bin/lsb_release
sed -i -e 's|/nix/store/[a-z0-9\._-]*/bin/||g' \
  /output/bin/lsb_release
