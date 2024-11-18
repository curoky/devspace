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

cmd="code"
install_total=${1:-0}

if ! command -v $cmd &>/dev/null; then
  cmd=~/.vscode-server/bin/default_version/bin/code-server
fi

if [[ $install_total -gt 0 ]]; then
  # code --list-extensions | awk '{print "--install-extension " $0 " \\"}'
  $cmd \
    --install-extension alefragnani.bookmarks \
    --install-extension bazelbuild.vscode-bazel \
    --install-extension cduruk.thrift \
    --install-extension charliermarsh.ruff \
    --install-extension chouzz.vscode-better-align \
    --install-extension christian-kohler.path-intellisense \
    --install-extension dakara.transformer \
    --install-extension esbenp.prettier-vscode \
    --install-extension foxundermoon.shell-format \
    --install-extension github.vscode-github-actions \
    --install-extension humao.rest-client \
    --install-extension mads-hartmann.bash-ide-vscode \
    --install-extension ms-azuretools.vscode-docker \
    --install-extension ms-python.debugpy \
    --install-extension ms-python.python \
    --install-extension ms-python.vscode-pylance \
    --install-extension ms-toolsai.jupyter \
    --install-extension ms-toolsai.jupyter-keymap \
    --install-extension ms-toolsai.jupyter-renderers \
    --install-extension ms-toolsai.vscode-jupyter-cell-tags \
    --install-extension ms-toolsai.vscode-jupyter-powertoys \
    --install-extension ms-toolsai.vscode-jupyter-slideshow \
    --install-extension ms-vscode.cpptools \
    --install-extension nvidia.nsight-vscode-edition \
    --install-extension pflannery.vscode-versionlens \
    --install-extension pkief.material-icon-theme \
    --install-extension rangav.vscode-thunder-client \
    --install-extension redhat.vscode-yaml \
    --install-extension richie5um2.vscode-sort-json \
    --install-extension ritwickdey.liveserver \
    --install-extension rpinski.shebang-snippets \
    --install-extension shd101wyy.markdown-preview-enhanced \
    --install-extension tabbyml.vscode-tabby \
    --install-extension tamasfe.even-better-toml \
    --install-extension xaver.clang-format \
    --install-extension yzhang.markdown-all-in-one \
    --install-extension zxh404.vscode-proto3
else
  $cmd \
    --install-extension alefragnani.bookmarks \
    --install-extension bazelbuild.vscode-bazel \
    --install-extension charliermarsh.ruff \
    --install-extension esbenp.prettier-vscode \
    --install-extension foxundermoon.shell-format \
    --install-extension ms-python.debugpy \
    --install-extension ms-python.python \
    --install-extension ms-python.vscode-pylance \
    --install-extension ms-vscode.cpptools \
    --install-extension tabbyml.vscode-tabby \
    --install-extension xaver.clang-format
  # --install-extension christian-kohler.path-intellisense \
  # --install-extension ginfuru.ginfuru-better-solarized-dark-theme \
  # --install-extension ms-toolsai.jupyter \
  # --install-extension ms-toolsai.jupyter-keymap \
  # --install-extension ms-toolsai.jupyter-renderers \
  # --install-extension ms-toolsai.vscode-jupyter-cell-tags \
  # --install-extension ms-toolsai.vscode-jupyter-powertoys \
  # --install-extension ms-toolsai.vscode-jupyter-slideshow \
  # --install-extension nvidia.nsight-vscode-edition \
  # --install-extension pflannery.vscode-versionlens \
  # --install-extension pkief.material-icon-theme \
  # --install-extension redhat.vscode-yaml \
  # --install-extension richie5um2.vscode-sort-json \
  # --install-extension rpinski.shebang-snippets \
  # --install-extension cduruk.thrift \
  # --install-extension chouzz.vscode-better-align \
  # --install-extension dakara.transformer \
  # --install-extension github.vscode-github-actions \
  # --install-extension mads-hartmann.bash-ide-vscode \
  # --install-extension ms-azuretools.vscode-docker \
  # --install-extension shd101wyy.markdown-preview-enhanced \
  # --install-extension tamasfe.even-better-toml \
  # --install-extension yzhang.markdown-all-in-one \
  # --install-extension zxh404.vscode-proto3 \
  # --install-extension ritwickdey.liveserver \
fi
