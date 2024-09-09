# syntax=docker/dockerfile:1.9.0
FROM nixpkgs/nix-unstable:latest AS nixpkgs-builder

ENV NIX_PATH=nixpkgs=channel:nixos-24.05

RUN nix-channel --add https://nixos.org/channels/nixos-24.05 nixpkgs \
  && nix-channel --update
ENV NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1
ENV NIXPKGS_ALLOW_BROKEN=1
# RUN nix-env -p /nix/var/nix/profiles/py311 -iA nixpkgs.pkgsStatic.python311

# RUN nix-env -p /nix/var/nix/profiles/krb5 -iA nixpkgs.pkgsStatic.git
# RUN nix-env -p /nix/var/nix/profiles/krb5 -iA nixpkgs.pkgsStatic.cmake
# RUN nix-env -p /nix/var/nix/profiles/krb5 -iA nixpkgs.pkgsStatic.openssh_gssapi
# RUN nix-env -p /nix/var/nix/profiles/krb5 -iA nixpkgs.pkgsStatic.man
# RUN nix-env -p /nix/var/nix/profiles/krb5 -iA nixpkgs.pkgsStatic.locale
# RUN nix-env -p /nix/var/nix/profiles/krb5 -iA nixpkgs.pkgsStatic.gnupg
# RUN nix-env -p /nix/var/nix/profiles/krb5 -iA nixpkgs.pkgsStatic.cloc
# RUN nix-env -p /nix/var/nix/profiles/krb5 -iA nixpkgs.pkgsStatic.perl
# RUN nix-env -p /nix/var/nix/profiles/krb5 -iA nixpkgs.pkgsStatic.pandoc
# RUN nix-env -p /nix/var/nix/profiles/krb5 -iA nixpkgs.pkgsStatic.graphviz
# RUN nix-env -p /nix/var/nix/profiles/krb5 -iA nixpkgs.pkgsStatic.wget
RUN nix-env -p /nix/var/nix/profiles/krb5 -iA nixpkgs.pkgsStatic.ncdu


# COPY default.nix .
# RUN nix-env -p /nix/var/nix/profiles/py311 -iA -f ./default.nix dstat_static

# FROM debian:bookworm-backports AS packer

# RUN apt-get update -y && apt-get install -y curl python3 python3-pip

# COPY --from=nixpkgs-builder /nix /nix
# COPY pack.py .

# RUN mkdir /output \
#   && ./pack.py

# FROM debian:bookworm-backports
# COPY --from=packer /output /output
