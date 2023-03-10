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

opencc_dir=/opt/homebrew/opt/rime-bundle/opencc

# cp $opencc_dir/rime-emoji/simple.emoji_category.txt $CONFIG_HOME/rime/squirrel/opencc/rime-emoji_simple.emoji_category.txt
# cp $opencc_dir/rime-emoji/simple.emoji_word.txt $CONFIG_HOME/rime/squirrel/opencc/rime-emoji_simple.emoji_word.txt
# cp $opencc_dir/rime-ice/emoji.txt $CONFIG_HOME/rime/squirrel/opencc/rime-ice_emoji.txt
# cp $opencc_dir/rime-ice/others.txt $CONFIG_HOME/rime/squirrel/opencc/rime-ice_others.txt

# cp $opencc_dir/rime-symbols/simple.symbol_word.txt $CONFIG_HOME/rime/squirrel/opencc/rime-symbols_simple.symbol_word.txt
# cp $opencc_dir/rime-symbols/simple.symbol_category.txt $CONFIG_HOME/rime/squirrel/opencc/rime-symbols_simple.symbol_category.txt

cp $opencc_dir/rime-emoji/emoji_category.txt $CONFIG_HOME/rime/squirrel/opencc/emoji_category.txt
cp $opencc_dir/rime-emoji/emoji_word.txt $CONFIG_HOME/rime/squirrel/opencc/emoji_word.txt
cp $opencc_dir/rime-ice/emoji.txt $CONFIG_HOME/rime/squirrel/opencc/emoji.txt

cp $opencc_dir/rime-symbols/symbol_word.txt $CONFIG_HOME/rime/squirrel/opencc/symbol_word.txt
cp $opencc_dir/rime-symbols/symbol_category.txt $CONFIG_HOME/rime/squirrel/opencc/symbol_category.txt

cp $opencc_dir/rime-ice/others.txt $CONFIG_HOME/rime/squirrel/opencc/symbol_others.txt
