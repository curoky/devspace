#!/usr/bin/env bash
# Copyright (c) 2018-2023 curoky(cccuroky@gmail.com).
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

update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 \
  15 \
  --slave /usr/bin/gcov gcov /usr/bin/gcov-11 \
  --slave /usr/bin/gcov-dump gcov-dump /usr/bin/gcov-dump-11 \
  --slave /usr/bin/gcov-tool gcov-tool /usr/bin/gcov-tool-11 \
  --slave /usr/bin/gcc-ar gcc-ar /usr/bin/gcc-ar-11 \
  --slave /usr/bin/gcc-nm gcc-nm /usr/bin/gcc-nm-11 \
  --slave /usr/bin/gcc-ranlib gcc-ranlib /usr/bin/gcc-ranlib-11

update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-11 15
update-alternatives --install /usr/bin/cc cc /usr/bin/gcc-11 15
update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++-11 15
