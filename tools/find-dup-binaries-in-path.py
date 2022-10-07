#!/usr/bin/env python3
# Copyright (c) 2018-2022 curoky(cccuroky@gmail.com).
#
# This file is part of dotbox.
# See https://github.com/curoky/dotbox.git for further info.
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
from collections import defaultdict
from genericpath import isdir
import sys
import os
from pathlib import Path

if __name__ == '__main__':
    paths = map(lambda x: Path(x), sorted(set(os.environ['PATH'].split(':'))))

    binsIndex = defaultdict(lambda: [])
    # binsFromPaths = {}
    for p in paths:
        if p.as_posix() in ('/sbin', '/bin'):
            continue
        if not p.is_dir():
            continue
        for f in filter(lambda x: x.is_file(), p.iterdir()):
            if f.as_posix().startswith('/nix/var/nix/profiles/') and f.is_symlink():
                f = f.readlink()
            binsIndex[f.name].append(f)
    for b, ps in binsIndex.items():
        if len(ps) != 1:
            print(b, ps)
