#!/usr/bin/env bash

ufw disable
curl -sSL https://github.com/go-gost/gost/releases/download/v3.0.0-rc7/gost_3.0.0-rc7_linux_amd64.tar.gz | tar -xz
nohup ./gost -L relay://:2222 &
