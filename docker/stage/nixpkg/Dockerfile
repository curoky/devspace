# syntax=docker/dockerfile:1.9.0
FROM debian:bookworm-backports

RUN apt-get update -y \
  && apt-get install -y curl xz-utils sudo \
  && groupadd -g 5230 -o x \
  && useradd -m -u 5230 -g 5230 x \
  && mkdir -m 0755 /nix \
  && chown x:x /nix

USER x

ENV PATH=$PATH:/nix/var/nix/profiles/default/bin:/home/x/.nix-profile/bin:/nix/var/nix/profiles/gcc13/bin \
  NIXPKGS_ALLOW_UNFREE=1 \
  NIXPKGS_ALLOW_BROKEN=1

RUN curl -L https://nixos.org/nix/install | sh -s -- --no-daemon \
  && nix-channel --update

COPY --from=third-party nixpkgs nixpkgs

RUN nix-env -p /nix/var/nix/profiles/default -iA \
    nixpkgs.pkg-config nixpkgs.libtool nixpkgs.automake nixpkgs.autoconf nixpkgs.man \
    nixpkgs.locale nixpkgs.graphviz \
    # nixpkgs.ccache nixpkgs.distcc nixpkgs.meson nixpkgs.scons nixpkgs.asciinema nixpkgs.bash
    # lua static
    nixpkgs.pandoc \
    # dotnet-sdk static failed
    nixpkgs.pre-commit \
    # perl5.40.0-Module test failed
    nixpkgs.cloc \
    # ModuleNotFoundError: No module named '_dbm
    nixpkgs.dstat \
    # libuv test failed
    nixpkgs.cmake \
    nixpkgs.nodePackages.prettier \
  && chmod +w /nix/var/nix/profiles/default/* \
  && nix-env -iA -p /nix/var/nix/profiles/libs nixpkgs.python311Packages.libtorrent-rasterbar \
      nixpkgs.ncurses5 nixpkgs.libxml2.out nixpkgs.libxcrypt nixpkgs.libbacktrace \
  && nix-collect-garbage
