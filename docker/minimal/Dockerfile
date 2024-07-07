ARG BASE_IMAGE=ubuntu:24.04
############################################################
#################   Conda && Pipx   ########################
############################################################
FROM debian:bookworm-backports as stage_conda
RUN apt-get update -y \
  && apt-get install -y curl gcc g++ git \
  && curl -sSL -o /tmp/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
  && bash /tmp/miniconda.sh -b -u -p /app/conda
ENV PIPX_HOME=/app/pipx \
  PIPX_BIN_DIR=/app/pipx/bin \
  PIPX_MAN_DIR=/app/pipx/share/man
RUN /app/conda/bin/pip3 install pipx \
  && /app/conda/bin/pipx install licenseheaders dotdrop
COPY docker/minimal/config/conda_env env
COPY docker/minimal/script/setup-conda-env.sh setup-conda-env.sh
RUN ./setup-conda-env.sh env/py2.yaml \
  && ./setup-conda-env.sh env/py3.yaml

############################################################
###################    Nixpkgs    ##########################
############################################################
FROM debian:bookworm-backports as stage_nixpkg
RUN apt-get update -y \
  && apt-get install -y curl xz-utils sudo
RUN groupadd -g 1000 -o x \
  && useradd -m -u 1000 -g 1000 x \
  && sudo mkdir -m 0755 /nix && sudo chown x:x /nix
USER x
ENV PATH=$PATH:/nix/var/nix/profiles/default/bin:/home/x/.nix-profile/bin:/nix/var/nix/profiles/gcc13/bin \
  NIXPKGS_ALLOW_UNFREE=1 \
  NIXPKGS_ALLOW_BROKEN=1
RUN curl -L https://nixos.org/nix/install | sh -s -- --no-daemon \
  && nix-channel --update
COPY third-party/nixpkgs nixpkgs
RUN nix-env -p /nix/var/nix/profiles/default -iA \
    # system core package
    nixpkgs.tzdata.out nixpkgs.locale nixpkgs.cacert \
    # compression
    nixpkgs.bzip2 nixpkgs.xz nixpkgs.zstd nixpkgs.zip nixpkgs.unzip nixpkgs.gnutar nixpkgs.zlib nixpkgs.zlib-ng nixpkgs.gzip nixpkgs.snappy \
    # download
    nixpkgs.gnupg nixpkgs.cacert nixpkgs.curl nixpkgs.wget nixpkgs.aria2 nixpkgs.rsync nixpkgs.croc \
    # edit
    nixpkgs.less nixpkgs.gnused nixpkgs.gnugrep nixpkgs.vim nixpkgs.bat nixpkgs.jq nixpkgs.flex \
    nixpkgs.bison nixpkgs.gettext nixpkgs.m4 \
    # compile
    nixpkgs.automake nixpkgs.autoconf nixpkgs.libtool nixpkgs.pkg-config nixpkgs.gnumake nixpkgs.cmake \
    # shell
    nixpkgs.zsh nixpkgs.bash nixpkgs.shfmt nixpkgs.starship nixpkgs.tmux nixpkgs.asciinema \
    # git
    nixpkgs.git nixpkgs.git-absorb nixpkgs.git-extras nixpkgs.git-lfs nixpkgs.git-filter-repo nixpkgs.gnupatch \
    # sre
    nixpkgs.iproute2 nixpkgs.iputils nixpkgs.netcat nixpkgs.lsof nixpkgs.connect nixpkgs.procps \
    nixpkgs.nettools nixpkgs.fd nixpkgs.ethtool nixpkgs.gdb nixpkgs.file nixpkgs.eza nixpkgs.fzf \
    nixpkgs.findutils nixpkgs.coreutils nixpkgs.lsb-release nixpkgs.tree nixpkgs.procs nixpkgs.gdu \
    nixpkgs.dstat nixpkgs.man nixpkgs.iptables nixpkgs.unixtools.xxd nixpkgs.util-linux nixpkgs.ncdu \
    nixpkgs.silver-searcher nixpkgs.diffutils nixpkgs.patchelf nixpkgs.strace \
    # linter
    nixpkgs.pre-commit nixpkgs.nodePackages.prettier nixpkgs.shfmt nixpkgs.ruff nixpkgs.clang-tools_16 \
    nixpkgs.buildifier \
    # other
    nixpkgs.cloc nixpkgs.go-task nixpkgs.krb5 nixpkgs.openssh_gssapi nixpkgs.pandoc \
  && nix-env -iA -p /nix/var/nix/profiles/vim-bundle -f nixpkgs/default.nix vim-bundle \
  && nix-env -iA -p /nix/var/nix/profiles/zsh-bundle -f nixpkgs/default.nix zsh-bundle \
  && nix-collect-garbage

############################################################
####################    Final    ###########################
############################################################
FROM $BASE_IMAGE

ENV PATH=$PATH:/nix/var/nix/profiles/default/bin \
  DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y \
  && apt-get install -y --no-install-recommends \
    sudo systemd

RUN userdel ubuntu -r || echo "ignore userdel failed" \
  && echo "root:123456" | chpasswd \
  && useradd --create-home --shell /nix/var/nix/profiles/default/bin/zsh --uid 1000 --user-group x \
  && echo "x:123456" | chpasswd \
  && usermod -aG sudo x \
  && echo "x ALL=(ALL:ALL) NOPASSWD:ALL" >>/etc/sudoers.d/nopasswd_user

COPY --chown=1000:1000 --link --from=stage_nixpkg /nix /nix
COPY --chown=1000:1000 --link --from=stage_nixpkg /home/x/.local/state/nix /home/x/.local/state/nix
COPY --chown=1000:1000 --link --from=stage_conda /app/conda /app/conda
COPY --chown=1000:1000 --link --from=stage_conda /app/pipx /app/pipx

######## Setup core system config ##########
RUN \
  # timezone
  ln -f /nix/var/nix/profiles/default/share/zoneinfo/Singapore /etc/localtime \
  # ca-certificates
  && mkdir -p /etc/ssl/certs/ \
  && cp /nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt /etc/ssl/certs/ca-certificates.crt \
  # locale
  && mkdir -p /usr/lib/locale \
  && ln -s /nix/var/nix/profiles/default/lib/locale/locale-archive /usr/lib/locale/locale-archive \
  && echo 'LANG=en_US.UTF-8' >/etc/locale.conf

######## Link some tools to /usr/local/bin ##########
RUN ln -s /app/pipx/bin/dotdrop /usr/local/bin

######## Step other system config and user config ##########
COPY --chown=1000:1000 ./ /app/dotbox
RUN dotdrop install --cfg=/app/dotbox/config/config.yaml --force --profile=docker-sysconf \
  && dotdrop install --cfg=/app/dotbox/config/config.yaml --force --profile=docker-userconf-final \
  # systemd
  && systemctl enable /app/dotbox/config/systemd/myssh.service \
  && useradd --uid 200 -g 65534 --home-dir /run/sshd --create-home --shell /usr/sbin/nologin sshd \
  && mkdir -p /var/empty

USER x
ENV PATH=$PATH:/home/x/.nix-profile/bin:/app/dotbox/docker/minimal/script

# Post setup for nixpkgs
RUN mkdir ~/.nix-defexpr \
  && ln -s ~/.local/state/nix/profiles/profile ~/.nix-profile \
  && ln -s ~/.local/state/nix/profiles/channels ~/.nix-defexpr/channels

RUN sudo mkdir -p /data/share /data/cache /data/workspace \
  && sudo chown x:x ~ /data /app ~/.local /app/conda /app/pipx \
  && dotdrop install --cfg=/app/dotbox/config/config.yaml --force --profile=docker-userconf-final

USER root
ENTRYPOINT ["/app/dotbox/docker/minimal/script/entrypoint.sh"]
