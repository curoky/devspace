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

# https://gist.github.com/b01/0a16b6645ab7921b0910603dfb85e4fb

# Auto-Get the latest commit sha via command line.
get_latest_release() {
  platform=${1}
  arch=${2}

  # Grab the first commit SHA since as this script assumes it will be the
  # latest.
  platform="win32"
  arch="x64"
  commit_id=$(curl --silent "https://update.code.visualstudio.com/api/commits/stable/${platform}-${arch}" | sed s'/^\["\([^"]*\).*$/\1/')

  printf "%s" "${commit_id}"
}

PLATFORM="${1}"
ARCH="${2}"

if [ -z "${PLATFORM}" ]; then
  echo "please enter a platform, acceptable values are win32, linux, darwin, or alpine"
  exit 1
fi

if [ -z "${ARCH}" ]; then
  U_NAME=$(uname -m)

  if [ "${U_NAME}" = "aarch64" ]; then
    ARCH="arm64"
  elif [ "${U_NAME}" = "x86_64" ]; then
    ARCH="x64"
  elif [ "${U_NAME}" = "armv7l" ]; then
    ARCH="armhf"
  fi
fi

commit_sha=$(get_latest_release "${PLATFORM}" "${ARCH}")

if [ -n "${commit_sha}" ]; then
  echo "will attempt to download VS Code Server version = '${commit_sha}'"

  prefix="server-${PLATFORM}"
  if [ "${PLATFORM}" = "alpine" ]; then
    prefix="cli-${PLATFORM}"
  fi

  archive="vscode-${prefix}-${ARCH}.tar.gz"
  # Download VS Code Server tarball to tmp directory.
  curl -L "https://update.code.visualstudio.com/commit:${commit_sha}/${prefix}-${ARCH}/stable" -o "/tmp/${archive}"

  # Make the parent directory where the server should live.
  # NOTE: Ensure VS Code will have read/write access; namely the user running VScode or container user.
  mkdir -vp ~/.vscode-server/bin/"${commit_sha}"

  # Extract the tarball to the right location.
  tar --no-same-owner -xzv --strip-components=1 -C ~/.vscode-server/bin/"${commit_sha}" -f "/tmp/${archive}"
  # Add symlink
  cd ~/.vscode-server/bin && ln -s "${commit_sha}" default_version
else
  echo "could not pre install vscode server"
fi
