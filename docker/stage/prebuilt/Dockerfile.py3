# syntax=docker/dockerfile:1.9.0
FROM nixpkgs/nix-unstable:latest AS nixpkgs-builder

ENV NIX_PATH=nixpkgs=channel:nixos-24.05
ENV NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1
ENV NIXPKGS_ALLOW_BROKEN=1

RUN nix-channel --add https://nixos.org/channels/nixos-24.05 nixpkgs \
  && nix-channel --update

RUN nix-env -p /nix/var/nix/profiles/extra -iA nixpkgs.pkgsStatic.dool
RUN nix-env -p /nix/var/nix/profiles/extra -iA nixpkgs.pkgsStatic.git-filter-repo

COPY default.nix .
RUN nix-env -p /nix/var/nix/profiles/extra -iA -f default.nix python311_static
