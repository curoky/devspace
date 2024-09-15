# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage

{ pkgs ? import <nixpkgs> { } }:

let
  gdu_static = pkgs.gdu.overrideAttrs (oldAttrs: rec {
    CGO_ENABLED = "0";
  });
  gh_static = pkgs.gh.overrideAttrs (oldAttrs: rec {
    CGO_ENABLED = "0";
  });
  bazelisk_static = pkgs.bazelisk.overrideAttrs (oldAttrs: rec {
    CGO_ENABLED = "0";
  });
  croc_static = pkgs.croc.overrideAttrs (oldAttrs: rec {
    CGO_ENABLED = "0";
  });
  go_task_static = pkgs.go-task.overrideAttrs (oldAttrs: rec {
    CGO_ENABLED = "0";
  });
  git_lfs_static = pkgs.git-lfs.overrideAttrs (oldAttrs: rec {
    CGO_ENABLED = "0";
  });
  gost_static = pkgs.gost.overrideAttrs (oldAttrs: rec {
    CGO_ENABLED = "0";
  });
  shfmt_static = pkgs.shfmt.overrideAttrs (oldAttrs: rec {
    CGO_ENABLED = "0";
  });
  fzf_static = pkgs.fzf.overrideAttrs (oldAttrs: rec {
    CGO_ENABLED = "0";
  });
  silver_searcher_static = pkgs.pkgsStatic.silver-searcher.overrideAttrs (oldAttrs: rec {
    NIX_LDFLAGS = "";
  });
  diffutils_static = pkgs.pkgsStatic.diffutils.overrideAttrs (oldAttrs: rec {
    doCheck = false;
  });
  wget_static = pkgs.pkgsStatic.wget.overrideAttrs (oldAttrs: rec {
    nativeBuildInputs = [ pkgs.gettext pkgs.pkg-config pkgs.lzip pkgs.libiconv pkgs.libintl ];
    doCheck = false;
  });
  protobuf3_20_static = pkgs.pkgsStatic.protobuf3_20.overrideAttrs (oldAttrs: rec {
    postInstall = ''
      mv $out/bin/protoc $out/bin/protoc-${oldAttrs.version}
    '';
  });
  protobuf_3_8_0_static = pkgs.pkgsStatic.protobuf3_20.overrideAttrs (oldAttrs: rec {
    src = pkgs.fetchFromGitHub {
      owner = "protocolbuffers";
      repo = "protobuf";
      rev = "v3.8.0";
      sha256 = "sha256-qK4Tb6o0SAN5oKLHocEIIKoGCdVFQMeBONOQaZQAlG4=";
    };
    postInstall = ''
      mv $out/bin/protoc $out/bin/protoc-3.8.0
    '';
  });
  protobuf_3_9_2_static = pkgs.pkgsStatic.protobuf3_20.overrideAttrs (oldAttrs: rec {
    src = pkgs.fetchFromGitHub {
      owner = "protocolbuffers";
      repo = "protobuf";
      rev = "v3.9.2";
      sha256 = "sha256-1mLSNLyRspTqoaTFylGCc2JaEQOMR1WAL7ffwJPqHyA=";
    };
    postInstall = ''
      mv $out/bin/protoc $out/bin/protoc-3.9.2
    '';
  });
  cmake_static = pkgs.pkgsStatic.cmakeMinimal.overrideAttrs (oldAttrs: rec {
    doCheck = false;
  });
  dstat_static = pkgs.pkgsStatic.dstat.overrideAttrs (oldAttrs: rec {
    doCheck = false;
    pytestCheckPhase = "";
    preDistPhases = [];
    installCheckPhase = false;
  });
  python311_static = pkgs.pkgsStatic.python311.overrideAttrs (oldAttrs: rec {
    # https://wiki.python.org/moin/BuildStatically
    # https://github.com/python/cpython/blob/3.11/Modules/Setup
    configureFlags = oldAttrs.configureFlags ++ [
      "LDFLAGS=-L${pkgs.pkgsStatic.termcap}/lib"
    ];
    postPatch = oldAttrs.postPatch + ''
      #sed -i 's/#*shared*/#*static*/g' Modules/Setup
      echo "math mathmodule.c" >> Modules/Setup.local
      echo "_posixsubprocess _posixsubprocess.c" >> Modules/Setup.local
      echo "resource resource.c" >> Modules/Setup.local
      echo "select selectmodule.c" >> Modules/Setup.local
      echo "fcntl fcntlmodule.c" >> Modules/Setup.local
      echo "_struct _struct.c" >> Modules/Setup.local
      echo "termios termios.c" >> Modules/Setup.local
      echo "_curses -lncurses -lncursesw -ltermcap _cursesmodule.c" >> Modules/Setup.local
    '';
  });
in
{
  inherit bazelisk_static;
  inherit croc_static;
  inherit gdu_static;
  inherit gh_static;
  inherit git_lfs_static;
  inherit go_task_static;
  inherit gost_static;
  inherit silver_searcher_static;
  inherit shfmt_static;
  inherit fzf_static;
  inherit wget_static;
  inherit diffutils_static;
  inherit protobuf3_20_static;
  inherit python311_static;
  inherit dstat_static;
  inherit protobuf_3_8_0_static;
  inherit protobuf_3_9_2_static;

  rsync_static = pkgs.pkgsStatic.rsync.override {
    enableXXHash = false;
  };
  coreutils_static = pkgs.pkgsStatic.coreutils.override {
    singleBinary = false;
  };
}
