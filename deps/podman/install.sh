#!/usr/bin/env bash
set -xeuo pipefail

# wget https://github.com/curoky/devspace/releases/download/v1.0/podman.tar
# tar -x -f podman.tar

rm -rf /opt/mypodman
mkdir -p /opt/mypodman
cp -r ./* /opt/mypodman

rm -rf /etc/containers/policy.json
mkdir -p /etc/containers/policy.json
cp ./conf/policy.json /etc/containers/policy.json

rm -rf /etc/systemd/system/mypodmand.service
mkdir -p /etc/systemd/system/
cp ./conf/mypodmand.service /etc/systemd/system/mypodmand.service

echo 'systemctl daemon-reload'
echo 'systemctl enable mypodmand.service'
echo 'systemctl start mypodmand.service'
echo 'systemctl status mypodmand.service'
echo 'chmod +777 /tmp/mypodman.sock'

echo 'nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml'
