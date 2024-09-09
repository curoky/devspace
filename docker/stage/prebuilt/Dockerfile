FROM nixpkgs/nix-unstable:latest as nixpkgs-builder

ENV NIX_PATH=nixpkgs=channel:nixos-24.05 \
  NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1

RUN nix-channel --add https://nixos.org/channels/nixos-24.05 nixpkgs \
  && nix-channel --update

RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.glibcLocales
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.aria2
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.autoconf
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.automake
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.bison
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.buildifier
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.bzip2
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.cacert
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.connect
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.curl
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.ethtool
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.file
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.findutils
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.flex
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.gettext
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.git-extras
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.gnugrep
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.gnumake
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.gnupatch
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.gnused
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.gnutar
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.gzip
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.iproute2
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
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.procps
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.snappy
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.strace
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.tmux
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.tree
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.unixtools.xxd
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.unzip
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.util-linux
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.xz
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.zip
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.zlib
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.zlib-ng
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.zstd
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.protobuf_24
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.lsb-release

RUN nix-env -p /nix/var/nix/profiles/default2 -iA nixpkgs.pkgsStatic.netcat
RUN nix-env -p /nix/var/nix/profiles/default3 -iA nixpkgs.pkgsStatic.openssl.bin
RUN nix-env -p /nix/var/nix/profiles/default4 -iA nixpkgs.pkgsStatic.tzdata.out

# https://askubuntu.com/questions/445686/vim-cannot-find-syntax-vim
RUN nix-env -p /nix/var/nix/profiles/extra -iA nixpkgs.pkgsStatic.vim
RUN nix-env -p /nix/var/nix/profiles/extra -iA nixpkgs.pkgsStatic.pkg-config-unwrapped
RUN nix-env -p /nix/var/nix/profiles/extra -iA nixpkgs.pkgsStatic.zsh
RUN nix-env -p /nix/var/nix/profiles/extra -iA nixpkgs.pkgsStatic.bash
RUN nix-env -p /nix/var/nix/profiles/extra -iA nixpkgs.pkgsStatic.dool
RUN nix-env -p /nix/var/nix/profiles/extra -iA nixpkgs.pkgsStatic.git-filter-repo
RUN nix-env -p /nix/var/nix/profiles/extra -iA nixpkgs.pkgsStatic.pkg-config
# RUN nix-env -p /nix/var/nix/profiles/extra -iA nixpkgs.pkgsStatic.gdb

COPY --from=third-party nixpkgs nixpkgs
RUN nix-env -p /nix/var/nix/profiles/default -iA -f ./nixpkgs/default.nix vim-bundle
RUN nix-env -p /nix/var/nix/profiles/default -iA -f ./nixpkgs/default.nix zsh-bundle

COPY default.nix .
RUN nix-env -p /nix/var/nix/profiles/default -iA -f default.nix bazelisk_static
RUN nix-env -p /nix/var/nix/profiles/default -iA -f default.nix coreutils_static
RUN nix-env -p /nix/var/nix/profiles/default -iA -f default.nix croc_static
RUN nix-env -p /nix/var/nix/profiles/default -iA -f default.nix fzf_static
RUN nix-env -p /nix/var/nix/profiles/default -iA -f default.nix gdu_static
RUN nix-env -p /nix/var/nix/profiles/default -iA -f default.nix gh_static
RUN nix-env -p /nix/var/nix/profiles/default -iA -f default.nix git_lfs_static
RUN nix-env -p /nix/var/nix/profiles/default -iA -f default.nix go_task_static
RUN nix-env -p /nix/var/nix/profiles/default -iA -f default.nix gost_static
RUN nix-env -p /nix/var/nix/profiles/default -iA -f default.nix rsync_static
RUN nix-env -p /nix/var/nix/profiles/default -iA -f default.nix shfmt_static
RUN nix-env -p /nix/var/nix/profiles/default -iA -f default.nix silver_searcher_static
RUN nix-env -p /nix/var/nix/profiles/default -iA -f default.nix diffutils_static
RUN nix-env -p /nix/var/nix/profiles/default5 -iA -f default.nix protobuf_3_8_0_static
RUN nix-env -p /nix/var/nix/profiles/default5 -iA -f default.nix protobuf_3_9_2_static
RUN nix-env -p /nix/var/nix/profiles/default5 -iA -f default.nix protobuf3_20_static
RUN nix-env -p /nix/var/nix/profiles/extra -iA -f default.nix python311_static

# FROM homebrew/brew:latest as brew-builder
# ENV HOMEBREW_NO_ANALYTICS=1
# COPY --from=third-party homebrew/Formula/ /home/linuxbrew/.linuxbrew/Homebrew/Library/Taps/x/homebrew-x/Formula/
# RUN brew install x/x/llvm-tools

FROM debian:bookworm-backports as packer

RUN apt-get update -y && apt-get install -y curl python3 python3-pip rsync

COPY --from=nixpkgs-builder /nix/ /nix/
COPY --from=curoky/dotbox:stage-prebuilt-llvm18 /output /output-llvm18
COPY --from=curoky/dotbox:stage-prebuilt-rust /output /output-rust
# COPY --chown=1000:1000 --from=brew-builder /home/linuxbrew/.linuxbrew/ /home/linuxbrew/.linuxbrew/

COPY pack.py .
COPY patch.sh .
RUN mkdir -p /output/bin /output/extra/bin \
  && ./pack.py \
  && ./patch.sh \
  && rsync --progress --archive --human-readable /output-llvm18/ /output/ \
  && rsync --progress --archive --human-readable /output-rust/ /output/ \
  && curl -sSL -o /output/bin/ncdu https://bin.ajam.dev/x86_64_Linux/ncdu \
  && curl -sSL -o /output/bin/wget https://bin.ajam.dev/x86_64_Linux/wget \
  && rm -rf /output/bin/xxd \
  && cp -L /nix/var/nix/profiles/default/bin/xxd /output/bin/xxd \
  && cd /output/bin \
  && ln -s bazelisk bazel \
  && ln -s clang-format-18 clang-format \
  && rm -rf bat && mv .bat-wrapped bat \
  && chmod +x ncdu wget

COPY wrapper/dool /output/bin/dool
COPY wrapper/git-filter-repo /output/bin/git-filter-repo

FROM debian:bookworm-backports
COPY --from=packer /output /output
