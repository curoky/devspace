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

# setup pipx monopoly
brew install gcc@11 pkg-config poppler ocrmypdf
/opt/conda/bin/pipx install monopoly-core
cp /opt/homebrew/opt/poppler/lib/*.dylib /opt/conda/pipx/venvs/monopoly-core/lib/
cp /opt/homebrew/opt/freetype/lib/*.dylib /opt/conda/pipx/venvs/monopoly-core/lib/
cp /opt/homebrew/opt/fontconfig/lib/*.dylib /opt/conda/pipx/venvs/monopoly-core/lib/
cp /opt/homebrew/opt/jpeg-turbo/lib/*.dylib /opt/conda/pipx/venvs/monopoly-core/lib/
cp /opt/homebrew/opt/gpgme/lib/*.dylib /opt/conda/pipx/venvs/monopoly-core/lib/
cp /opt/homebrew/opt/openjpeg/lib/*.dylib /opt/conda/pipx/venvs/monopoly-core/lib/
cp /opt/homebrew/opt/little-cms2/lib/*.dylib /opt/conda/pipx/venvs/monopoly-core/lib/
cp /opt/homebrew/opt/libpng/lib/*.dylib /opt/conda/pipx/venvs/monopoly-core/lib/
cp /opt/homebrew/opt/libtiff/lib/*.dylib /opt/conda/pipx/venvs/monopoly-core/lib/
cp /opt/homebrew/opt/nss/lib/*.dylib /opt/conda/pipx/venvs/monopoly-core/lib/
cp /opt/homebrew/opt/nspr/lib/*.dylib /opt/conda/pipx/venvs/monopoly-core/lib/
cp /opt/homebrew/opt/libassuan/lib/*.dylib /opt/conda/pipx/venvs/monopoly-core/lib/
cp /opt/homebrew/opt/libgpg-error/lib/*.dylib /opt/conda/pipx/venvs/monopoly-core/lib/
cp /opt/homebrew/opt/xz/lib/*.dylib /opt/conda/pipx/venvs/monopoly-core/lib/
cp /opt/homebrew/opt/zstd/lib/*.dylib /opt/conda/pipx/venvs/monopoly-core/lib/

# install_name_tool -change /opt/homebrew/opt/poppler/lib/libpoppler-cpp.2.dylib /opt/conda/pipx/venvs/monopoly-core/lib/libpoppler-cpp.2.dylib /opt/conda/pipx/venvs/monopoly-core/lib/python3.12/site-packages/pdftotext.cpython-312-darwin.so
# install_name_tool \
#   -change /opt/homebrew/opt/freetype/lib/libfreetype.6.dylib /opt/conda/pipx/venvs/monopoly-core/lib/libfreetype.6.dylib \
#   -change /opt/homebrew/opt/fontconfig/lib/libfontconfig.1.dylib /opt/conda/pipx/venvs/monopoly-core/lib/libfontconfig.1.dylib \
#   -change /opt/homebrew/opt/jpeg-turbo/lib/libjpeg.8.dylib /opt/conda/pipx/venvs/monopoly-core/lib/libjpeg.8.dylib \
#   -change /opt/homebrew/opt/gpgme/lib/libgpgmepp.6.dylib /opt/conda/pipx/venvs/monopoly-core/lib/libgpgmepp.6.dylib \
#   -change /opt/homebrew/opt/openjpeg/lib/libopenjp2.7.dylib /opt/conda/pipx/venvs/monopoly-core/lib/libopenjp2.7.dylib \
#   -change /opt/homebrew/opt/little-cms2/lib/liblcms2.2.dylib /opt/conda/pipx/venvs/monopoly-core/lib/liblcms2.2.dylib \
#   -change /opt/homebrew/opt/libpng/lib/libpng16.16.dylib /opt/conda/pipx/venvs/monopoly-core/lib/libpng16.16.dylib \
#   -change /opt/homebrew/opt/libtiff/lib/libtiff.6.dylib /opt/conda/pipx/venvs/monopoly-core/lib/libtiff.6.dylib \
#   -change /opt/homebrew/opt/nss/lib/libnss3.dylib /opt/conda/pipx/venvs/monopoly-core/lib/libnss3.dylib \
#   -change /opt/homebrew/opt/nss/lib/libnssutil3.dylib /opt/conda/pipx/venvs/monopoly-core/lib/libnssutil3.dylib \
#   -change /opt/homebrew/opt/nss/lib/libsmime3.dylib /opt/conda/pipx/venvs/monopoly-core/lib/libsmime3.dylib \
#   -change /opt/homebrew/opt/nss/lib/libssl3.dylib /opt/conda/pipx/venvs/monopoly-core/lib/libssl3.dylib \
#   -change /opt/homebrew/opt/nspr/lib/libplds4.dylib /opt/conda/pipx/venvs/monopoly-core/lib/libplds4.dylib \
#   -change /opt/homebrew/opt/nspr/lib/libplc4.dylib /opt/conda/pipx/venvs/monopoly-core/lib/libplc4.dylib \
#   -change /opt/homebrew/opt/nspr/lib/libnspr4.dylib /opt/conda/pipx/venvs/monopoly-core/lib/libnspr4.dylib \
#   -change /opt/homebrew/opt/gpgme/lib/libgpgme.11.dylib /opt/conda/pipx/venvs/monopoly-core/lib/libgpgme.11.dylib \
#   -change /opt/homebrew/opt/libassuan/lib/libassuan.9.dylib /opt/conda/pipx/venvs/monopoly-core/lib/libassuan.9.dylib \
#   /opt/conda/pipx/venvs/monopoly-core/lib/libpoppler.146.dylib

# install_name_tool \
#   -change /opt/homebrew/opt/gpgme/lib/libgpgmepp.6.dylib /opt/conda/pipx/venvs/monopoly-core/lib/libgpgmepp.6.dylib \
#   -change /opt/homebrew/Cellar/gpgme/1.24.2/lib/libgpgme.11.dylib /opt/conda/pipx/venvs/monopoly-core/lib/libgpgme.11.dylib \
#   -change /opt/homebrew/opt/libassuan/lib/libassuan.9.dylib /opt/conda/pipx/venvs/monopoly-core/lib/libassuan.9.dylib \
#   /opt/conda/pipx/venvs/monopoly-core/lib/libgpgmepp.6.dylib

# install_name_tool \
#   -change /opt/homebrew/opt/nss/lib/libnss3.dylib /opt/conda/pipx/venvs/monopoly-core/lib/libnss3.dylib \
#   -change /opt/homebrew/opt/nss/lib/libnssutil3.dylib /opt/conda/pipx/venvs/monopoly-core/lib/libnssutil3.dylib \
#   -change /opt/homebrew/opt/nspr/lib/libplds4.dylib /opt/conda/pipx/venvs/monopoly-core/lib/libplds4.dylib \
#   -change /opt/homebrew/opt/nspr/lib/libplc4.dylib /opt/conda/pipx/venvs/monopoly-core/lib/libplc4.dylib \
#   -change /opt/homebrew/opt/nspr/lib/libnspr4.dylib /opt/conda/pipx/venvs/monopoly-core/lib/libnspr4.dylib \
#   /opt/conda/pipx/venvs/monopoly-core/lib/libnss3.dylib

# install_name_tool \
#   -change /opt/homebrew/opt/libassuan/lib/libassuan.9.dylib /opt/conda/pipx/venvs/monopoly-core/lib/libassuan.9.dylib \
#   -change /opt/homebrew/opt/libgpg-error/lib/libgpg-error.0.dylib /opt/conda/pipx/venvs/monopoly-core/lib/libgpg-error.0.dylib \
#   /opt/conda/pipx/venvs/monopoly-core/lib/libassuan.9.dylib

# install_name_tool \
#   -change /opt/homebrew/opt/libassuan/lib/libassuan.9.dylib /opt/conda/pipx/venvs/monopoly-core/lib/libassuan.9.dylib \
#   -change /opt/homebrew/opt/gpgme/lib/libgpgme.11.dylib /opt/conda/pipx/venvs/monopoly-core/lib/libgpgme.11.dylib \
#   -change /opt/homebrew/opt/libgpg-error/lib/libgpg-error.0.dylib /opt/conda/pipx/venvs/monopoly-core/lib/libgpg-error.0.dylib \
#   /opt/conda/pipx/venvs/monopoly-core/lib/libgpgme.11.dylib

# install_name_tool \
#   -change /opt/homebrew/opt/nspr/lib/libplc4.dylib /opt/conda/pipx/venvs/monopoly-core/lib/libplc4.dylib \
#   -change /opt/homebrew/opt/nspr/lib/libnspr4.dylib /opt/conda/pipx/venvs/monopoly-core/lib/libnspr4.dylib \
#   /opt/conda/pipx/venvs/monopoly-core/lib/libplc4.dylib

# install_name_tool \
#   -change /opt/homebrew/opt/nspr/lib/libplds4.dylib /opt/conda/pipx/venvs/monopoly-core/lib/libplds4.dylib \
#   -change /opt/homebrew/opt/nspr/lib/libnspr4.dylib /opt/conda/pipx/venvs/monopoly-core/lib/libnspr4.dylib \
#   /opt/conda/pipx/venvs/monopoly-core/lib/libplds4.dylib

# install_name_tool \
#   -change /opt/homebrew/opt/nss/lib/libssl3.dylib /opt/conda/pipx/venvs/monopoly-core/lib/libssl3.dylib \
#   -change /opt/homebrew/opt/nss/lib/libnss3.dylib /opt/conda/pipx/venvs/monopoly-core/lib/libnss3.dylib \
#   -change /opt/homebrew/opt/nss/lib/libnssutil3.dylib /opt/conda/pipx/venvs/monopoly-core/lib/libnssutil3.dylib \
#   -change /opt/homebrew/opt/nspr/lib/libplds4.dylib /opt/conda/pipx/venvs/monopoly-core/lib/libplds4.dylib \
#   -change /opt/homebrew/opt/nspr/lib/libplc4.dylib /opt/conda/pipx/venvs/monopoly-core/lib/libplc4.dylib \
#   -change /opt/homebrew/opt/nspr/lib/libnspr4.dylib /opt/conda/pipx/venvs/monopoly-core/lib/libnspr4.dylib \
#   /opt/conda/pipx/venvs/monopoly-core/lib/libssl3.dylib

# install_name_tool \
#   -change /opt/homebrew/opt/nss/lib/libsmime3.dylib /opt/conda/pipx/venvs/monopoly-core/lib/libsmime3.dylib \
#   -change /opt/homebrew/opt/nss/lib/libnss3.dylib /opt/conda/pipx/venvs/monopoly-core/lib/libnss3.dylib \
#   -change /opt/homebrew/opt/nss/lib/libnssutil3.dylib /opt/conda/pipx/venvs/monopoly-core/lib/libnssutil3.dylib \
#   -change /opt/homebrew/opt/nss/lib/libnssutil3.dylib /opt/conda/pipx/venvs/monopoly-core/lib/libnssutil3.dylib \
#   -change /opt/homebrew/opt/nspr/lib/libplds4.dylib /opt/conda/pipx/venvs/monopoly-core/lib/libplds4.dylib \
#   -change /opt/homebrew/opt/nspr/lib/libplc4.dylib /opt/conda/pipx/venvs/monopoly-core/lib/libplc4.dylib \
#   /opt/conda/pipx/venvs/monopoly-core/lib/libsmime3.dylib

# install_name_tool \
#   -change /opt/homebrew/opt/libtiff/lib/libtiff.6.dylib /opt/conda/pipx/venvs/monopoly-core/lib/libtiff.6.dylib \
#   -change /opt/homebrew/opt/zstd/lib/libzstd.1.dylib /opt/conda/pipx/venvs/monopoly-core/lib/libzstd.1.dylib \
#   -change /opt/homebrew/opt/xz/lib/liblzma.5.dylib /opt/conda/pipx/venvs/monopoly-core/lib/liblzma.5.dylib \
#   -change /opt/homebrew/opt/jpeg-turbo/lib/libjpeg.8.dylib /opt/conda/pipx/venvs/monopoly-core/lib/libjpeg.8.dylib \
#   /opt/conda/pipx/venvs/monopoly-core/lib/libtiff.6.dylib

tar -c --gunzip -f tmp/conda.darwin-arm64.tar.gz /opt/conda
