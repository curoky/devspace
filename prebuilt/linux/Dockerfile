# syntax=docker/dockerfile:1.9.0
FROM nixpkgs/nix-unstable:latest AS builder

ENV NIX_PATH=nixpkgs=channel:nixos-24.11 \
  PATH=${PATH}:/root/.nix-profile/bin

RUN nix-channel --add https://nixos.org/channels/nixos-24.11 nixpkgs \
  && nix-channel --update

RUN nix-env -iA nixpkgs.findutils nixpkgs.curl nixpkgs.gnused

COPY setup-pipx.sh .
RUN ./setup-pipx.sh

COPY common.sh .
COPY pack-for-docker.sh .
COPY wrapper wrapper

RUN ./pack-for-docker.sh
RUN mkdir -p tmp/prebuilt/dotbox \
  && curl -sSL https://github.com/curoky/dotbox/archive/refs/heads/dev.tar.gz \
    | tar -xv --gunzip -C tmp/prebuilt/dotbox --strip-components 1

FROM debian:bookworm-slim
COPY --from=builder /tmp/prebuilt /output
