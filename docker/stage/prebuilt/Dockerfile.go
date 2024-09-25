# syntax=docker/dockerfile:1.9.0
FROM nixpkgs/nix-unstable:latest AS nixpkgs-builder

ENV NIX_PATH=nixpkgs=channel:nixos-24.05

RUN nix-channel --add https://nixos.org/channels/nixos-24.05 nixpkgs \
  && nix-channel --update

RUN nix-env -p /nix/var/nix/profiles/extra -iA nixpkgs.pkgsStatic.buildifier

COPY default.nix .
RUN nix-env -p /nix/var/nix/profiles/default -iA -f default.nix gdu_static
RUN nix-env -p /nix/var/nix/profiles/default -iA -f default.nix croc_static
RUN nix-env -p /nix/var/nix/profiles/default -iA -f default.nix go_task_static
RUN nix-env -p /nix/var/nix/profiles/default -iA -f default.nix git_lfs_static
RUN nix-env -p /nix/var/nix/profiles/default -iA -f default.nix shfmt_static
RUN nix-env -p /nix/var/nix/profiles/default -iA -f default.nix fzf_static

RUN nix-env -p /nix/var/nix/profiles/extra -iA -f default.nix gh_static
RUN nix-env -p /nix/var/nix/profiles/extra -iA -f default.nix gost_static
RUN nix-env -p /nix/var/nix/profiles/extra -iA -f default.nix bazelisk_static

############################## END ##############################
RUN nix-env -p /nix/var/nix/profiles/packer -iA nixpkgs.python3

COPY pack.py .
RUN /nix/var/nix/profiles/packer/bin/python3 ./pack.py

FROM debian:bookworm-backports
COPY --from=nixpkgs-builder /output /output
