{ lib, stdenv, python3, fetchurl, fetchFromGitHub, cmake, fetchzip, opencc, unzip, python3Packages, pkgs}:

stdenv.mkDerivation rec {
  pname = "rime-bundle";
  version = "0.15.2";

  src = fetchurl {
    url = "https://github.com/rime/squirrel/archive/refs/tags/${version}.tar.gz";
    sha256 = "sha256-H/o6oI3shXYhvufOkvTKJZPQKowm/mmMwnTl1jP3/bA=";
  };

  buildInputs = [
    opencc
    unzip
  ];

  rime_emoji = fetchurl {
    url = "https://github.com/rime/rime-emoji/archive/master.tar.gz";
    sha256 = "sha256-HBccbmWCx/4xWf+qyImmxu4ybgM3iuGSIEFlUU0IdNU=";
  };

  meow_emoji_rime = fetchurl {
    url = "https://github.com/hitigon/meow-emoji-rime/archive/master.tar.gz";
    sha256 = "sha256-9MLmX/bV4M4DJ5Eha7ZgET8WMZAYtMU7pXsoD0gIiAo=";
  };

  rime_prelude = fetchurl {
    url = "https://github.com/rime/rime-prelude/archive/master.tar.gz";
    sha256 = "sha256-RHx20UXSpvbYtuelcn6nkZOoyXmqzdZykg7AAojvks8=";
  };

  rime_symbols = fetchurl {
    url = "https://github.com/fkxxyz/rime-symbols/archive/master.tar.gz";
    sha256 = "sha256-+t3b3EoqFQ3Sl2UJBRQ+9h0sM26Y+o8QMxXKw+aDI5A=";
  };

  rime_dict = fetchurl {
    url = "https://github.com/Iorest/rime-dict/archive/master.tar.gz";
    sha256 = "sha256-PFdXM6HtuxLrC/pikRzhfqhx0eotbLEQ2PA0+GkywjU=";
  };

  rime_cloverpinyin = fetchurl {
    url = "https://github.com/fkxxyz/rime-cloverpinyin/releases/download/1.1.4/clover.schema-1.1.4.zip";
    sha256 = "sha256-Mn1qb5pndyRAGZzklh3a4KukAHgoUSLTJ1hP8Rb9R4s=";
  };

  rime_ice = fetchurl {
    url = "https://github.com/iDvel/rime-ice/archive/main.tar.gz";
    sha256 = "sha256-cH+7mHH4fuzuExJ94DGlJj9fIb8iEUUttrrk/MfMiU4=";
  };

  phases = ["buildPhase" "installPhase" ];

  buildPhase = ''
  '';

  installPhase = ''
    mkdir -p $out/rime-bundle/opencc/rime-emoji \
      $out/rime-bundle/opencc/rime-symbols \
      $out/rime-bundle/dicts/rime-dict \
      $out/rime-bundle/dicts/rime-ice \
      $out/rime-bundle/dicts/rime-cloverpinyin

    # rime-symbols
    #tar -xzf ${rime_symbols} --strip-components=1 -C $out/rime-bundle/opencc/rime-symbols
    #python3 $out/rime-bundle/opencc/rime-symbols/rime-symbols-gen
    #for file in $out/rime-bundle/opencc/rime-symbols/*.txt; do
    #  opencc -i $file -o "$out/rime-bundle/opencc/rime-symbols/simple.$(basename $file)" -c t2s.json
    #done

    # rime-emoji
    mkdir ./rime-emoji
    mkdir -p $out/rime-bundle/opencc/rime-emoji/opencc
    tar -xzf ${rime_emoji} --strip-components=2 -C $out/rime-bundle/opencc/rime-emoji/
    for file in $out/rime-bundle/opencc/rime-emoji/*.txt; do
      opencc -i $file -o "$out/rime-bundle/opencc/rime-emoji/simple.$(basename $file)" -c t2s.json
    done

    # rime-dict
    mkdir ./rime-dict
    tar -xzf ${rime_dict} --strip-components=1 -C ./rime-dict
    for file in ./rime-dict/**/*.dict.yaml; do
      opencc -i $file -o "$out/rime-bundle/dicts/rime-dict/simple.$(basename $file)" -c t2s.json
    done

    # rime-cloverpinyin
    unzip ${rime_cloverpinyin} -d $out/rime-bundle/dicts/rime-cloverpinyin

    # rime-ice
    tar -xzf ${rime_ice} --strip-components=1 -C $out/rime-bundle/dicts/rime-ice
  '';

  meta = with lib; {
    description = "Bundle for Rime";
  };
}
