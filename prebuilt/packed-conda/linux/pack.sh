#!/usr/bin/env bash
set -xeuo pipefail

export PATH=$PATH:/sbin

sudo rm -rf /home/x/app/conda
sudo mkdir -p /home/x/app/conda
sudo chown "$(id -u):$(id -g)" /home/x/app/conda

rm -rf tmp
mkdir -p tmp
curl -sSL -o tmp/miniconda.sh \
  https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash tmp/miniconda.sh -b -u -p /home/x/app/conda

# setup env
../../../docker/stage/conda/setup-conda-env.sh -e ../../../docker/stage/conda/env/py3.yaml --conda_root=/home/x/app/conda
../../../docker/stage/conda/setup-conda-env.sh -e ../../../docker/stage/conda/env/profiling.yaml --conda_root=/home/x/app/conda

# setup pipx
/home/x/app/conda/bin/pip3 install pipx
export PIPX_HOME=/home/x/app/conda/pipx
export PIPX_BIN_DIR=${PIPX_HOME}/bin
export PIPX_MAN_DIR=${PIPX_HOME}/share/man
/home/x/app/conda/bin/pipx install licenseheaders

cp installer.sh /home/x/app/conda/installer.sh

makeself --complevel 6 --tar-quietly --gzip --threads 16 /home/x/app/conda tmp/conda.linux-x86_64.gzip.sh "Prebuilt Installer" /dev/null
makeself --complevel 9 --tar-quietly --zstd --threads 16 /home/x/app/conda tmp/conda.linux-x86_64.zstd.sh "Prebuilt Installer" /dev/null

# tar -c --gunzip -f tmp/conda.linux-x86_64.tar.gz /home/x/app/conda
