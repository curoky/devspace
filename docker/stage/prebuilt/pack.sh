#!/usr/bin/env bash

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
