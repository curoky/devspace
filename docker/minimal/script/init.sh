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

# remove ubuntu user
RUN userdel ubuntu -r || echo "ignore userdel failed"

# setup user root
echo "root:123456" | chpasswd
chsh -s /nix/var/nix/profiles/default/bin/zsh

# setup user x
# useradd --create-home --shell /nix/var/nix/profiles/default/bin/zsh --uid 1000 --user-group x
# echo "x:123456" | chpasswd
# usermod -aG sudo x
# echo "x ALL=(ALL:ALL) NOPASSWD:ALL" >>/etc/sudoers.d/nopasswd_user

# setup timezone
ln -sf /nix/var/nix/profiles/default/share/zoneinfo/Singapore /etc/localtime

# setup ca-certificates
mkdir -p /etc/ssl/certs/
cp /nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt /etc/ssl/certs/ca-certificates.crt

# setup locale
mkdir -p /usr/lib/locale
ln -sf /nix/var/nix/profiles/default/lib/locale/locale-archive /usr/lib/locale/locale-archive
echo 'LANG=en_US.UTF-8' >/etc/locale.conf

# setup other system config
dotdrop install --cfg=/app/dotbox/config/config.yaml --force --profile=docker-sysconf

# setup dotfiles for root
ln -sf /app/dotbox /root/dotbox
dotdrop install --cfg=/app/dotbox/config/config.yaml --force --profile=docker-userconf-final

# setup dotfiles for x
if [[ -d /data/share/dotbox ]]; then
  ln -sf /data/share/dotbox /home/x/dotbox
else
  ln -sf /app/dotbox /home/x/dotbox
fi
sudo -i -u x bash <<EOF
  /app/pipx/bin/dotdrop install --cfg=/home/x/dotbox/config/config.yaml --force --profile=docker-userconf-final
EOF

# prepare some path
mkdir -p /data/share /data/workspace
chown x:x /home/x /home/x/.local \
  /data /data/share /data/workspace \
  /app /app/conda /app/pipx
chmod 600 /home/x/dotbox/config/sshd/host-key/ssh_host_rsa_key

# setup cache dir
mkdir -p /data/cache
chown x:x /data/cache
rm -rf /home/x/.cache
ln -sf /data/cache /home/x/.cache

# setup vscode-server cache
if [[ -d /data/cache/vscode-server ]]; then
  rm -rf /home/x/.vscode-server
  ln -s /data/cache/vscode-server /home/x/.vscode-server
  chown x:x /data/cache/vscode-server
fi

# setup sshd
# systemctl enable /app/dotbox/config/systemd/myssh.service
useradd --uid 200 -g 65534 --home-dir /run/sshd --create-home --shell /usr/sbin/nologin sshd
mkdir -p /var/empty
