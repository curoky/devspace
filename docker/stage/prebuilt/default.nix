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
  silver_searcher_static = pkgs.pkgsStatic.silver-searcher.overrideAttrs (oldAttrs: rec {
    NIX_LDFLAGS = "";
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

  rsync_static = pkgs.libxml2.override {
    enableXXHash = false;
  };
  coreutils_static = pkgs.pkgsStatic.coreutils.override {
    singleBinary = false;
  };
}
