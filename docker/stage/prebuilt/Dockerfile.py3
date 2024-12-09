# syntax=docker/dockerfile:1.9.0
FROM nixpkgs/nix-unstable:latest AS nixpkgs-builder

ENV NIX_PATH=nixpkgs=channel:nixos-24.11
ENV NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1
ENV NIXPKGS_ALLOW_BROKEN=1

RUN nix-channel --add https://nixos.org/channels/nixos-24.11 nixpkgs \
  && nix-channel --update

COPY default.nix .
RUN nix-env -p /nix/var/nix/profiles/py311-static -iA -f default.nix python311_static
RUN nix-env -p /nix/var/nix/profiles/py311 -iA nixpkgs.python311Packages.pipx

COPY pipx-install.sh .
RUN ./pipx-install.sh licenseheaders dotdrop netron git-filter-repo dool asciinema licenseheaders

############################## END ##############################
RUN nix-env -p /nix/var/nix/profiles/packer -iA nixpkgs.python3

COPY pack.py .
RUN /nix/var/nix/profiles/packer/bin/python3 ./pack.py

FROM debian:bookworm-backports
COPY --from=nixpkgs-builder /output /output
