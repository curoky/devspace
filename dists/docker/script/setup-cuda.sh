#!/usr/bin/env bash
# Copyright (c) 2018-2023 curoky(cccuroky@gmail.com).
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

curl -sSL -o cuda_linux.run \
  https://developer.download.nvidia.com/compute/cuda/11.8.0/local_installers/cuda_11.8.0_520.61.05_linux.run

chmod +x cuda_linux.run

./cuda_linux.run --silent --toolkit

rm -f cuda_linux.run

# install cuda driver
# RUN curl -sSL -o nvidia_linux.run \
#     https://us.download.nvidia.com/tesla/450.248.02/NVIDIA-Linux-x86_64-450.248.02.run \
#   && chmod +x nvidia_linux.run \
#   && ./nvidia_linux.run --silent \
#     --no-kernel-module \
#   && rm -f nvidia_linux.run

# install cuda
# RUN curl -sSL -o cuda_linux.run \
#     https://developer.download.nvidia.com/compute/cuda/11.8.0/local_installers/cuda_11.8.0_520.61.05_linux.run \
#   && chmod +x cuda_linux.run \
#   && ./cuda_linux.run --silent --toolkit \
#   && rm -f cuda_linux.run
