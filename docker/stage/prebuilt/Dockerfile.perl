# syntax=docker/dockerfile:1.9.0
FROM nixpkgs/nix-unstable:latest AS nixpkgs-builder

ENV NIX_PATH=nixpkgs=channel:nixpkgs-unstable

RUN nix-channel --add https://github.com/NixOS/nixpkgs/archive/staging.tar.gz nixpkgs \
  && nix-channel --update

RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.perl
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.man
RUN nix-env -p /nix/var/nix/profiles/extra -iA nixpkgs.pkgsStatic.autoconf
RUN nix-env -p /nix/var/nix/profiles/extra -iA nixpkgs.pkgsStatic.automake
RUN nix-env -p /nix/var/nix/profiles/extra -iA nixpkgs.pkgsStatic.pkg-config
RUN nix-env -p /nix/var/nix/profiles/extra -iA nixpkgs.pkgsStatic.libtool
# RUN nix-env -p /nix/var/nix/profiles/extra -iA nixpkgs.pkgsStatic.pkg-config-unwrapped


COPY default.nix .
RUN nix-env -p /nix/var/nix/profiles/default -iA -f default.nix git_static
