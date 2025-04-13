#!/usr/bin/env bash
set -xeuo pipefail

rm -rf tmp/docker
mkdir -p tmp/docker

curl -sSL -o tmp/docker/libseccomp2_2.5.4-1+b3_amd64.deb \
  http://ftp.debian.org/debian/pool/main/libs/libseccomp/libseccomp2_2.5.4-1+b3_amd64.deb

# https://download.docker.com/linux/debian/dists/bullseye/pool/stable/amd64/

pkg_list=(
  containerd.io_1.6.22-1
  docker-ce-cli_24.0.5-1~debian.11~bullseye
  docker-ce_24.0.5-1~debian.11~bullseye
  # docker-buildx-plugin_0.11.2-1~debian.11~bullseye
  docker-buildx-plugin_0.16.2-1~debian.11~bullseye
  docker-compose-plugin_2.20.2-1~debian.11~bullseye
)

for pkg in ${pkg_list[@]}; do
  curl -sSL -o tmp/docker/${pkg}.deb \
    https://download.docker.com/linux/debian/dists/bullseye/pool/stable/amd64/${pkg}_amd64.deb
done

# https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html
pkg_list=(
  libnvidia-container1_1.13.5-1
  libnvidia-container-tools_1.13.5-1
  nvidia-container-toolkit-base_1.13.5-1
  nvidia-container-toolkit_1.13.5-1
)
for pkg in ${pkg_list[@]}; do
  curl -sSL -o tmp/docker/${pkg}.deb \
    https://github.com/NVIDIA/libnvidia-container/raw/gh-pages/stable/debian10/amd64/${pkg}_amd64.deb
done

cd tmp
tar -c --gunzip -f docker.debian10.tar.gz docker
