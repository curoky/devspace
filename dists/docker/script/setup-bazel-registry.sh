#!/usr/bin/env bash
set -xeuo pipefail

mkdir -p /opt/bazel/registry

git clone --depth=1 https://github.com/bazelbuild/bazel-central-registry /opt/bazel/registry/bazel-central-registry
git clone --depth=1 https://github.com/eomii/bazel-eomii-registry /opt/bazel/registry/bazel-eomii-registry
git clone --depth=1 https://github.com/curoky/bazel-curoky-registry /opt/bazel/registry/bazel-curoky-registry
