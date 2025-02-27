#!/usr/bin/env bash
set -xeuo pipefail

export PATH=$PATH:/sbin

sudo rm -rf /opt/conda
sudo mkdir /opt/conda
sudo chown "$(id -u):$(id -g)" /opt/conda

rm -rf tmp
mkdir -p tmp
curl -sSL -o tmp/miniconda.sh \
  https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh
# https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
sed -i -e 's/| md5/| openssl md5/g' tmp/miniconda.sh
bash tmp/miniconda.sh -b -u -p /opt/conda

# setup env
../../docker/stage/conda/setup-conda-env.sh -e ../../host/mac/conf/conda/py3.yaml --conda_root=/opt/conda

# setup pipx
/opt/conda/bin/pip3 install pipx
export PIPX_HOME=/opt/conda/pipx
export PIPX_BIN_DIR=${PIPX_HOME}/bin
export PIPX_MAN_DIR=${PIPX_HOME}/share/man
/opt/conda/bin/pipx install licenseheaders

tar -c --gunzip -f tmp/conda.darwin-arm64.tar.gz /opt/conda
