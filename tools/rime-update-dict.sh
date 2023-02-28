#!/usr/bin/env bash

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
