#!/usr/bin/bash
set -xeuo pipefail

docker pull curoky/devspace:tabby
docker tag curoky/devspace:tabby tabbyml/tabby
docker rmi curoky/devspace:tabby
docker rm --force tabbyd
mkdir -p $HOME/tabby/data
# --chat-model Qwen2.5-Coder-32B-Instruct
docker run -d --network=host --gpus all \
  -v $HOME/tabby/data:/data \
  --name tabbyd tabbyml/tabby \
  serve --no-webserver --model Qwen2.5-Coder-14B --device cuda --port 5847 --host ::
