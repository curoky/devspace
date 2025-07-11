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

rm -rf tmp/
mkdir -p tmp/devspace
curl -sSL https://github.com/curoky/devspace/archive/refs/heads/dev.tar.gz | tar -x --gunzip -C tmp/devspace --strip-components 1

cp installer.sh tmp/devspace

makeself --complevel 6 --tar-quietly --gzip --threads 16 tmp/devspace tmp/devspace-installer.gzip.sh "devspace Installer" ./installer.sh
