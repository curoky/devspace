#!/usr/bin/env bash
# Copyright (c) 2018-2025 curoky(cccuroky@gmail.com).
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

urls=(
  https://ftp.debian.org/debian/pool/main/libs/libseccomp/libseccomp2_2.6.0-2_amd64.deb

  # https://download.docker.com/linux/debian/dists/bullseye/pool/stable/amd64/containerd.io_1.6.22-1_amd64.deb
  # https://download.docker.com/linux/debian/dists/bullseye/pool/stable/amd64/docker-ce-cli_24.0.5-1~debian.11~bullseye_amd64.deb
  # https://download.docker.com/linux/debian/dists/bullseye/pool/stable/amd64/docker-ce_24.0.5-1~debian.11~bullseye_amd64.deb
  # https://download.docker.com/linux/debian/dists/bullseye/pool/stable/amd64/docker-buildx-plugin_0.16.2-1~debian.11~bullseye_amd64.deb
  # https://download.docker.com/linux/debian/dists/bullseye/pool/stable/amd64/docker-compose-plugin_2.20.2-1~debian.11~bullseye_amd64.deb

  https://download.docker.com/linux/debian/dists/bullseye/pool/stable/amd64/containerd.io_1.7.27-1_amd64.deb
  https://download.docker.com/linux/debian/dists/bullseye/pool/stable/amd64/docker-ce-cli_28.0.4-1~debian.11~bullseye_amd64.deb
  https://download.docker.com/linux/debian/dists/bullseye/pool/stable/amd64/docker-ce_28.0.4-1~debian.11~bullseye_amd64.deb
  https://download.docker.com/linux/debian/dists/bullseye/pool/stable/amd64/docker-buildx-plugin_0.22.0-1~debian.11~bullseye_amd64.deb
  https://download.docker.com/linux/debian/dists/bullseye/pool/stable/amd64/docker-compose-plugin_2.29.7-1~debian.11~bullseye_amd64.deb

  # https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html
  # https://github.com/NVIDIA/libnvidia-container/raw/gh-pages/stable/debian10/amd64/libnvidia-container1_1.13.5-1_amd64.deb
  # https://github.com/NVIDIA/libnvidia-container/raw/gh-pages/stable/debian10/amd64/libnvidia-container-tools_1.13.5-1_amd64.deb
  # https://github.com/NVIDIA/libnvidia-container/raw/gh-pages/stable/debian10/amd64/nvidia-container-toolkit-base_1.13.5-1_amd64.deb
  # https://github.com/NVIDIA/libnvidia-container/raw/gh-pages/stable/debian10/amd64/nvidia-container-toolkit_1.13.5-1_amd64.deb

  https://github.com/NVIDIA/libnvidia-container/raw/gh-pages/stable/deb/amd64/libnvidia-container1_1.17.5-1_amd64.deb
  https://github.com/NVIDIA/libnvidia-container/raw/gh-pages/stable/deb/amd64/libnvidia-container-tools_1.17.5-1_amd64.deb
  https://github.com/NVIDIA/libnvidia-container/raw/gh-pages/stable/deb/amd64/nvidia-container-toolkit-base_1.17.5-1_amd64.deb
  https://github.com/NVIDIA/libnvidia-container/raw/gh-pages/stable/deb/amd64/nvidia-container-toolkit_1.17.5-1_amd64.deb
)

rm -rf tmp/docker
mkdir -p tmp/docker

for url in "${urls[@]}"; do
  curl -sSL -o tmp/docker/$(basename "$url") "$url"
done

cp installer.sh tmp/docker/installer.sh

makeself --complevel 6 --tar-quietly --gzip --threads 16 tmp/docker tmp/docker-installer.debian10.gzip.sh "Docker Installer" /dev/null
makeself --complevel 16 --tar-quietly --zstd --threads 16 tmp/docker tmp/docker-installer.debian10.zstd.sh "Docker Installer" /dev/null
