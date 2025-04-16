#!/usr/bin/env bash
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
../../../docker/stage/conda/setup-conda-env.sh -e ../../../host/darwin/conf/conda/py3.yaml --conda_root=/Users/x/app/conda
../../../docker/stage/conda/setup-conda-env.sh -e ../../../host/darwin/conf/conda/monopoly.yaml --conda_root=/Users/x/app/conda

# setup pipx
/Users/x/app/conda/bin/pip3 install pipx
export PIPX_HOME=/Users/x/app/conda/pipx
export PIPX_BIN_DIR=${PIPX_HOME}/bin
export PIPX_MAN_DIR=${PIPX_HOME}/share/man
/Users/x/app/conda/bin/pipx install licenseheaders

cp installer.sh /Users/x/app/conda/installer.sh

makeself --complevel 6 --tar-quietly --gzip --threads 16 /Users/x/app/conda tmp/conda-envs.darwin-arm64.gzip.sh "Conda Installer" ./installer.sh
makeself --complevel 16 --tar-quietly --zstd --threads 16 /Users/x/app/conda tmp/conda-envs.darwin-arm64.zstd.sh "Conda Installer" ./installer.sh
