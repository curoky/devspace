# syntax=docker/dockerfile:1.9.0
FROM debian:bookworm-backports

RUN apt-get update -y \
  && apt-get install -y curl xz-utils sudo \
  && groupadd -g 1000 -o x \
  && useradd -m -u 1000 -g 1000 x \
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
    nixpkgs.vim nixpkgs.wget \
    # nixpkgs.pkg-config nixpkgs.libtool nixpkgs.automake nixpkgs.autoconf \
    # nixpkgs.gdb nixpkgs.man \
    nixpkgs.dstat nixpkgs.git nixpkgs.gnupg \
    nixpkgs.krb5 nixpkgs.locale nixpkgs.nixfmt nixpkgs.nixpkgs-fmt \
    nixpkgs.graphviz nixpkgs.nodePackages.prettier nixpkgs.pandoc \
    # nixpkgs.ccache nixpkgs.distcc nixpkgs.meson nixpkgs.scons nixpkgs.asciinema nixpkgs.bash
    # dotnet-sdk static failed
    nixpkgs.pre-commit \
    # perl5.40.0-Module test failed
    nixpkgs.cloc \
    # on 24.05 configure: error: ** Incomplete or missing ldns libraries
    # on staging krb5 multiple definition of `master_keyblock'; kdb5_util
    nixpkgs.openssh_gssapi  \
    # libuv test failed
    nixpkgs.cmake \
  && chmod +w /nix/var/nix/profiles/default/* \
  && nix-env -iA -p /nix/var/nix/profiles/libs nixpkgs.python311Packages.libtorrent-rasterbar \
      nixpkgs.ncurses5 nixpkgs.libxml2.out nixpkgs.libxcrypt nixpkgs.libbacktrace \
  && nix-collect-garbage
