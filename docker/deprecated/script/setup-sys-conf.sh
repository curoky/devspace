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

# timezone
ln -f /nix/var/nix/profiles/default/share/zoneinfo/Singapore /etc/localtime

# cert
# export SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
# export NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
mkdir -p /etc/ssl/certs/
cp /nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt /etc/ssl/certs/ca-certificates.crt

# locales
mkdir -p /usr/lib/locale
ln -s /nix/var/nix/profiles/default/lib/locale/locale-archive /usr/lib/locale/locale-archive
echo 'LANG=en_US.UTF-8' >/etc/locale.conf

# systemd
systemctl enable /app/dotbox/config/systemd/myssh.service
useradd --uid 200 -g 65534 --home-dir /run/sshd --create-home --shell /usr/sbin/nologin sshd
mkdir -p /var/empty
