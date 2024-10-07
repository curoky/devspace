#!/usr/bin/env bash
set -xeuo pipefail

curl -sSL -o /tmp/miniserve https://github.com/svenstaro/miniserve/releases/download/v0.28.0/miniserve-0.28.0-x86_64-unknown-linux-musl
chmod +x /tmp/miniserve
