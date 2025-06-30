#!/usr/bin/env bash
set -xeuo pipefail

rm -rf /opt/mypodman
mkdir -p /opt/mypodman
cp -r ./* /opt/mypodman

rm -rf /etc/containers
mkdir -p /etc/containers
cp -r ./conf/* /etc/containers

rm -rf /etc/systemd/system/mypodmand.service
mkdir -p /etc/systemd/system/
cp ./conf/mypodmand.service /etc/systemd/system/mypodmand.service

echo 'systemctl daemon-reload'
echo 'systemctl enable mypodmand.service'
echo 'systemctl start mypodmand.service'
echo 'systemctl status mypodmand.service'
echo 'chmod +777 /tmp/mypodman.sock'
