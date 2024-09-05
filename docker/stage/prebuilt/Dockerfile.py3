FROM nixpkgs/nix-unstable:latest as nixpkgs-builder

ENV NIX_PATH=nixpkgs=channel:nixos-24.05

RUN nix-channel --add https://nixos.org/channels/nixos-24.05 nixpkgs \
  && nix-channel --update

RUN nix-env -p /nix/var/nix/profiles/py311 -iA nixpkgs.pkgsStatic.python311
RUN nix-env -p /nix/var/nix/profiles/py311 -iA nixpkgs.pkgsStatic.dool
# RUN nix-env -p /nix/var/nix/profiles/py311 -iA nixpkgs.pkgsStatic.dstat

FROM debian:bookworm-backports as packer

COPY --from=nixpkgs-builder /nix /nix
RUN apt-get update -y && apt-get install -y curl python3 python3-pip

COPY pack.py .
RUN mkdir /output \
  && ./pack.py

FROM debian:bookworm-backports
COPY --from=packer /output /output
