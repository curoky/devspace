FROM debian:bookworm-backports as builder

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

RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.autoconf
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.automake
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.bat
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.bison
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.buildifier
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.bzip2
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.connect
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.coreutils
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.curl
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.ethtool
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.eza
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.fd
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.file
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.findutils
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.flex
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.fzf
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.gettext
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.gnugrep
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.gnumake
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.gnupatch
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.gnused
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.gnutar
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.gzip
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.iputils
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.jq
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.less
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.libcap
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.libtool
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.lsof
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.m4
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.nettools
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.ninja
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.patchelf
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.pkg-config
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.procps
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.ruff
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.shfmt
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.snappy
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.strace
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.unixtools.xxd
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.unzip
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.vim
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.xz
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.zip
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.zlib
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.zlib-ng
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.zstd
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.tree
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.aria2
# RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.pandoc

# need put it last
RUN nix-env -p /nix/var/nix/profiles/default2 -iA nixpkgs.pkgsStatic.netcat

COPY default.nix .
RUN nix-env -p /nix/var/nix/profiles/default -iA -f default.nix gdu_static
# RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.ncdu
# RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.bash
# RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.zsh
# RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.diffutils
# RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.silver-searcher

COPY pack.sh .

RUN ./pack.sh /tmp/output

FROM debian:bookworm-backports

COPY --chown=1000:1000 --from=builder /tmp/output /output
