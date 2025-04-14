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

enable_gpu=${1:-0}

apt-get remove -y \
  docker-ce docker-ce-cli containerd.io \
  docker-buildx-plugin docker-compose-plugin \
  nvidia-container-toolkit nvidia-container-toolkit-base \
  libnvidia-container-tools libnvidia-container1 || echo ignore

apt-get update -y
apt-get install -y iptables

dpkg -i tmp/docker/libseccomp2_2.5.4-1+b3_amd64.deb

dpkg -i tmp/docker/containerd.io_1.6.22-1.deb \
  tmp/docker/docker-ce_24.0.5-1~debian.11~bullseye.deb \
  tmp/docker/docker-ce-cli_24.0.5-1~debian.11~bullseye.deb \
  tmp/docker/docker-buildx-plugin_0.16.2-1~debian.11~bullseye.deb \
  tmp/docker/docker-compose-plugin_2.20.2-1~debian.11~bullseye.deb

if [[ $enable_gpu == 1 ]]; then
  dpkg -i tmp/docker/libnvidia-container1_1.13.5-1.deb \
    tmp/docker/libnvidia-container-tools_1.13.5-1.deb \
    tmp/docker/nvidia-container-toolkit-base_1.13.5-1.deb \
    tmp/docker/nvidia-container-toolkit_1.13.5-1.deb
fi

# Post stage for docker

# usermod -aG docker $USER

# cat /etc/docker/daemon.json
# {
#     "data-root": "/data00/docker",
#     "runtimes": {
#         "nvidia": {
#             "path": "nvidia-container-runtime",
#             "runtimeArgs": []
#         }
#     }
# }

# docker run --rm --runtime=nvidia --gpus all ubuntu nvidia-smi

systemctl daemon-reload
systemctl restart docker
