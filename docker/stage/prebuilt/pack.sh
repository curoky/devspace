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

root=/nix/var/nix/profiles/default/bin

output=$1
mkdir $output

for f in $(find $root -type l); do
  real_f=$(readlink -f $f)
  if file $real_f | grep -q "statically linked"; then
    # check if basename of real_f is equal to f
    if [[ $(basename $real_f) != $(basename $f) ]]; then
      echo "Skipping $f"
      continue
    fi
    cp $real_f $output
  fi
done
