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

# wget https://github.com/curoky/devspace/releases/download/v1.0/podman.tar
# tar -x -f podman.tar

rm -rf /opt/mypodman
mkdir -p /opt/mypodman
cp -r ./* /opt/mypodman

rm -rf /etc/containers/policy.json
mkdir -p /etc/containers
cp ./conf/policy.json /etc/containers/

rm -rf /etc/systemd/system/mypodmand.service
mkdir -p /etc/systemd/system/
cp ./conf/mypodmand.service /etc/systemd/system/mypodmand.service

echo 'systemctl daemon-reload'
echo 'systemctl enable mypodmand.service'
echo 'systemctl start mypodmand.service'
echo 'systemctl status mypodmand.service'
echo 'chmod +777 /tmp/mypodman.sock'

echo 'nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml'
