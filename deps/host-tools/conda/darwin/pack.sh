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

export PATH=$PATH:/sbin

if ! id -u x &>/dev/null; then
  sudo mkdir -p /Users/x/
  sudo chown -R $(id -u):$(id -g) /Users/x/
fi

rm -rf tmp && mkdir -p tmp
curl -sSL -o tmp/miniconda.sh \
  https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh
sed -i -e 's/| md5/| openssl md5/g' tmp/miniconda.sh
bash tmp/miniconda.sh -b -u -p /Users/x/app/conda

# setup env
../../../../dist/image/stage/conda/setup-conda-env.sh -e ../../../../dist/host/darwin/conf/conda/py3.yaml --conda_root=/Users/x/app/conda
../../../../dist/image/stage/conda/setup-conda-env.sh -e ../../../../dist/host/darwin/conf/conda/monopoly.yaml --conda_root=/Users/x/app/conda

# setup pipx
/Users/x/app/conda/bin/pip3 install pipx
export PIPX_HOME=/Users/x/app/conda/pipx
export PIPX_BIN_DIR=${PIPX_HOME}/bin
export PIPX_MAN_DIR=${PIPX_HOME}/share/man
/Users/x/app/conda/bin/pipx install licenseheaders

cp installer.sh /Users/x/app/conda/installer.sh

makeself --tar-format gnu --complevel 6 --tar-quietly --gzip --threads 16 /Users/x/app/conda tmp/conda-envs-installer.darwin-arm64.gzip.sh "Conda Installer" ./installer.sh
makeself --tar-format gnu --complevel 16 --tar-quietly --zstd --threads 16 /Users/x/app/conda tmp/conda-envs-installer.darwin-arm64.zstd.sh "Conda Installer" ./installer.sh
