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

/app/dotbox/dists/docker/script/link-host-dir.sh

sed -i -e "s/Port 61000/Port ${DEVBOX_SSHD_PORT:-61000}/g" /app/dotbox/config/sshd/sshd_config.conf

if [[ -d /home/x/dotbox ]]; then
  dotdrop install --force --cfg=/home/x/dotbox/config/config.yaml --profile=docker-userconf-final
fi

exec /lib/systemd/systemd
