
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
    nixpkgs.asciinema nixpkgs.bash nixpkgs.ccache nixpkgs.clang-tools_16 nixpkgs.cloc nixpkgs.cmake \
    nixpkgs.diffutils nixpkgs.distcc nixpkgs.dstat nixpkgs.gdb nixpkgs.git nixpkgs.git-extras \
    nixpkgs.git-filter-repo nixpkgs.glibcLocales nixpkgs.gnupg nixpkgs.graphviz nixpkgs.iproute2 \
    nixpkgs.krb5 nixpkgs.locale nixpkgs.lsb-release nixpkgs.man nixpkgs.meson nixpkgs.ncdu nixpkgs.nixfmt \
    nixpkgs.nixpkgs-fmt nixpkgs.nodePackages.prettier nixpkgs.openssh_gssapi nixpkgs.pandoc \
    nixpkgs.pre-commit nixpkgs.rsync nixpkgs.scons nixpkgs.silver-searcher nixpkgs.wget nixpkgs.zsh \
    nixpkgs.vim \
  && nix-env -iA -p /nix/var/nix/profiles/protobuf_3_8_0 -f nixpkgs/default.nix protobuf_3_8_0 \
  && nix-env -iA -p /nix/var/nix/profiles/protobuf_3_9_2 -f nixpkgs/default.nix protobuf_3_9_2 \
  && nix-env -iA -p /nix/var/nix/profiles/protobuf_3_20 nixpkgs.protobuf3_20 \
  && nix-env -iA -p /nix/var/nix/profiles/protobuf_24 nixpkgs.protobuf_24 \
  && nix-env -iA -p /nix/var/nix/profiles/vim-bundle -f nixpkgs/default.nix vim-bundle \
  && nix-env -iA -p /nix/var/nix/profiles/zsh-bundle -f nixpkgs/default.nix zsh-bundle \
  && chmod +w /nix/var/nix/profiles/default/* \
  && nix-env -iA -p /nix/var/nix/profiles/libs nixpkgs.python311Packages.libtorrent-rasterbar \
      nixpkgs.ncurses5 nixpkgs.libxml2.out nixpkgs.libxcrypt nixpkgs.libbacktrace \
  && nix-collect-garbage
