#!/usr/bin/env bash
set -xeuo pipefail

function download_pkg() {
  pkg=$1
  arch=${2:-linux_amd64}
  mkdir -p tmp/download
  mkdir -p tmp/prebuilt/pkgs/${pkg}
  curl -sSL -o tmp/download/${pkg}.tar.gz https://github.com/curoky/prebuilt/releases/download/v1.0/${pkg}.${arch}.tar.gz
  tar -x --gunzip -f tmp/download/${pkg}.tar.gz -C tmp/prebuilt/pkgs/${pkg} --strip-components 2
}

function link_bin() {
  mkdir -p tmp/prebuilt/bin
  find tmp/prebuilt/pkgs/*/bin -type f -exec ln -s -r {} $PWD/tmp/prebuilt/bin/ \;
}

function strip_bin() {
  chmod -R +w tmp/prebuilt/
  for f in $(find tmp/prebuilt/ -executable -type f); do
    if file "$f" | grep -q 'ELF'; then
      strip --strip-unneeded "$f"
    fi
  done
}

function remove_unneeded() {
  find tmp/prebuilt/ -name "*.a" -delete
  find tmp/prebuilt/ -name "*.pyc" -delete

  # remove ld from binutils
  # /app/prebuilt/extra/bin/ld.gold: error: /usr/lib/gcc/x86_64-linux-gnu/8/liblto_plugin.so: could not load plugin library: Dynamic loading not supported
  rm -rf tmp/prebuilt/bin/ld tmp/prebuilt/bin/ld.bfd tmp/prebuilt/bin/ld.gold
}

function rename_wrapped() {

  find tmp/prebuilt/pkgs/*/bin -type f -name ".*-wrapped" | while read -r file; do
    dir=$(dirname "$file")
    new_name=$(basename "$file" | sed -e 's/-wrapped//g' -e 's/^.//')
    mv "$file" "$dir/$new_name"
  done
}

function copy_wrapper() {
  cp --remove-destination wrapper/* tmp/prebuilt/bin/
}

function add_dotbox() {
  mkdir -p tmp/prebuilt/dotbox
  curl -sSL https://github.com/curoky/dotbox/archive/refs/heads/dev.tar.gz | tar -xv --gunzip -C tmp/prebuilt/dotbox --strip-components 1
}
