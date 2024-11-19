# syntax=docker/dockerfile:1.9.0
FROM nixpkgs/nix-unstable:latest AS nixpkgs-builder

ENV NIX_PATH=nixpkgs=channel:nixos-24.11

RUN nix-channel --add https://nixos.org/channels/nixos-24.11 nixpkgs \
  && nix-channel --update

RUN nix-env -p /nix/var/nix/profiles/experimental -iA nixpkgs.pkgsStatic.perl
RUN nix-env -p /nix/var/nix/profiles/experimental -iA nixpkgs.pkgsStatic.man
RUN nix-env -p /nix/var/nix/profiles/experimental -iA nixpkgs.pkgsStatic.autoconf
RUN nix-env -p /nix/var/nix/profiles/experimental -iA nixpkgs.pkgsStatic.automake
RUN nix-env -p /nix/var/nix/profiles/experimental -iA nixpkgs.pkgsStatic.pkg-config
RUN nix-env -p /nix/var/nix/profiles/experimental -iA nixpkgs.pkgsStatic.libtool
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.gdb
# RUN nix-env -p /nix/var/nix/profiles/experimental -iA nixpkgs.pkgsStatic.pkg-config-unwrapped

############################## END ##############################
RUN nix-env -p /nix/var/nix/profiles/packer -iA nixpkgs.python3

COPY pack.py .
RUN /nix/var/nix/profiles/packer/bin/python3 ./pack.py

FROM debian:bookworm-backports
COPY --from=nixpkgs-builder /output /output
