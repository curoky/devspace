#!/usr/bin/env bash
set -xeuo pipefail

rm -rf tmp/pypi
mkdir -p tmp/pypi/

curl -sSL -o tmp/pypi/dool.whl \
  https://files.pythonhosted.org/packages/24/66/3c81d509ce2658d9abf6950eca40b6bd765d677b48abdddee19ef83daac6/dool-1.3.4-py3-none-any.whl
curl -sSL -o tmp/pypi/netron.whl \
  https://files.pythonhosted.org/packages/cb/a3/051d987c3357c752d1f7cf9438092d4ed1e4f0e270a5b2ab49191e5e46c2/netron-8.2.7-py3-none-any.whl
curl -sSL -o tmp/pypi/git_filter_repo.whl \
  https://files.pythonhosted.org/packages/60/60/d3943f0880ebcb7e0bdf79254d10dddd39c7b656eeecae32b8806ff66dec/git_filter_repo-2.47.0-py3-none-any.whl

mkdir -p tmp/pypi/dool/lib/python3.11/site-packages/
mkdir -p tmp/pypi/netron/lib/python3.11/site-packages/
mkdir -p tmp/pypi/git-filter-repo/lib/python3.11/site-packages/

unzip tmp/pypi/dool.whl -d tmp/pypi/dool/lib/python3.11/site-packages/
unzip tmp/pypi/netron.whl -d tmp/pypi/netron/lib/python3.11/site-packages/
unzip tmp/pypi/git_filter_repo.whl -d tmp/pypi/git-filter-repo/lib/python3.11/site-packages/

cp -r pypkgs/dool tmp/pypi/dool/bin
cp -r pypkgs/netron tmp/pypi/netron/bin
cp -r pypkgs/git-filter-repo tmp/pypi/git-filter-repo/bin

mv tmp/pypi/dool tmp/pypi/git-filter-repo tmp/pypi/netron tmp/sre-tools/pkgs
