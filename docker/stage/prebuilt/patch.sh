#!/usr/bin/env bash
# Copyright (c) 2018-2024 curoky(cccuroky@gmail.com).
#
# This file is part of dotbox.
# See https://github.com/curoky/dotbox for further info.
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

sed -i 's$pluginpath = \[$pluginpath = \[os\.path\.dirname\(__file__\)+"/\.\./share/dool/",$g' \
  /output/extra/bin/dool
sed -i '1s|.*|#!/usr/bin/env bash|' /output/bin/lsb_release
sed -i -e 's|/nix/store/[a-z0-9\._-]*/bin/||g' \
  /output/bin/lsb_release
