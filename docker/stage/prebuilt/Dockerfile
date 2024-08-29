FROM debian:bookworm-backports as builder

RUN apt-get update -y \
  && apt-get install -y curl xz-utils sudo python3 python3-pip \
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

RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.aria2
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.atuin
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.autoconf
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.automake
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.bat
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.bison
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.buildifier
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.bzip2
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.cacert
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
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.git-absorb
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.gnugrep
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.gnumake
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.gnupatch
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.gnused
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.gnutar
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.gzip
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.iptables
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
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.procs
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.ruff
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.shfmt
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.snappy
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.starship
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.strace
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.tmux
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.tree
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.unixtools.xxd
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.unzip
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.util-linux
# RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.vim
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.xz
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.zip
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.zlib
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.zlib-ng
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.zstd

# need put it last
RUN nix-env -p /nix/var/nix/profiles/default2 -iA nixpkgs.pkgsStatic.netcat
RUN nix-env -p /nix/var/nix/profiles/default3 -iA nixpkgs.pkgsStatic.openssl.bin
RUN nix-env -p /nix/var/nix/profiles/default4 -iA nixpkgs.pkgsStatic.tzdata.out

COPY default.nix .
RUN nix-env -p /nix/var/nix/profiles/default -iA -f default.nix bazelisk_static
RUN nix-env -p /nix/var/nix/profiles/default -iA -f default.nix croc_static
RUN nix-env -p /nix/var/nix/profiles/default -iA -f default.nix gdu_static
RUN nix-env -p /nix/var/nix/profiles/default -iA -f default.nix gh_static
RUN nix-env -p /nix/var/nix/profiles/default -iA -f default.nix git_lfs_static
RUN nix-env -p /nix/var/nix/profiles/default -iA -f default.nix go_task_static
RUN nix-env -p /nix/var/nix/profiles/default -iA -f default.nix gost_static

COPY pack.py .
RUN ./pack.py

FROM debian:bookworm-backports

ENV PATH=$PATH:/output/bin

COPY --chown=1000:1000 --from=builder /tmp/output /output

RUN apt-get update -y && apt-get install -y curl

RUN curl -sSL -o /output/bin/ncdu https://bin.ajam.dev/x86_64_Linux/ncdu \
  && curl -sSL -o /output/bin/wget https://bin.ajam.dev/x86_64_Linux/wget \
  && curl -sSL -o /output/bin/rsync https://bin.ajam.dev/x86_64_Linux/rsync \
  && curl -sSL -o /output/bin/clang-format-16 https://github.com/muttleyxd/clang-tools-static-binaries/releases/download/master-32d3ac78/clang-format-16_linux-amd64 \
  && curl -sSL -o /output/bin/clang-format-18 https://github.com/muttleyxd/clang-tools-static-binaries/releases/download/master-32d3ac78/clang-format-18_linux-amd64 \
  && chmod +x /output/bin/ncdu /output/bin/wget /output/bin/rsync \
    /output/bin/clang-format-16 /output/bin/clang-format-18

RUN cd /output/bin \
  && ln -s bazelisk bazel \
  && ln -s clang-format-16 clang-format
