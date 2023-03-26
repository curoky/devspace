FROM homebrew/brew:latest as homebrew
COPY images/script/setup-pkg-brew.sh setup-pkg-brew.sh
COPY images/config/brew/Brewfile.linux Brewfile.linux
ENV HOMEBREW_NO_ANALYTICS=1 \
  HOMEBREW_INSTALL_FROM_API=1
RUN rm -rf /home/linuxbrew/.linuxbrew/Homebrew/Library/Taps/homebrew/homebrew-core \
  && ./setup-pkg-brew.sh Brewfile.linux

FROM ghcr.io/conda/conda-ci:master-linux-python3.10 as conda
USER root
COPY images/config/pip/*.txt .
RUN /opt/conda/bin/conda create -n py2 python=2 --yes \
  && /opt/conda/envs/py2/bin/pip install --no-cache-dir -r requirements-py2.txt \
  && /opt/conda/bin/conda create -n py3 python=3.11 -c conda-forge --yes \
  && /opt/conda/envs/py3/bin/pip install --no-cache-dir -r requirements-py3.txt \
  && /opt/conda/bin/conda clean --all -y

FROM ubuntu:latest as vcpkg
RUN apt-get update -qq \
  && apt-get install -y -qq --no-install-recommends \
    ca-certificates git curl zip unzip tar \
  && git clone https://github.com/microsoft/vcpkg /opt/vcpkg \
  && cd /opt/vcpkg \
  && ./bootstrap-vcpkg.sh -disableMetrics

FROM golang:latest as golang
COPY images/config/go/requirements.txt requirements.txt
COPY images/script/setup-pkg-go.sh setup-pkg-go.sh
RUN ./setup-pkg-go.sh requirements.txt

FROM nixos/nix as nixpkgs
COPY images/script/setup-pkg-nix.sh setup-pkg-nix.sh
RUN nix-channel --update \
  && ./setup-pkg-nix.sh

FROM ubuntu:22.10
LABEL org.opencontainers.image.authors="cccuroky@gmail.com"

# Note: g=u doesn't really work. https://github.com/moby/buildkit/issues/1951
COPY --chown=1000:1000 --chmod=g=u --from=curoky/sidecar:spark /opt/hadoop /opt/hadoop
COPY --chown=1000:1000 --chmod=g=u --from=curoky/sidecar:spark /opt/spark /opt/spark
COPY --chown=1000:1000 --chmod=g=u --from=curoky/sidecar:flink /opt/flink /opt/flink
COPY --chown=1000:1000 --chmod=g=u --from=curoky/sidecar:hive /opt/hive /opt/hive
COPY --chown=1000:1000 --chmod=g=u --from=golang /root/go/bin /home/cicada/go/bin
COPY --chown=1000:1000 --chmod=g=u --from=vcpkg /opt/vcpkg /opt/vcpkg
COPY --chown=1000:1000 --chmod=g=u --from=conda /opt/conda /opt/conda
COPY --chown=1000:1000 --chmod=g=u --from=homebrew /home/linuxbrew /home/linuxbrew
COPY --chown=1000:1000 --chmod=g=u --from=nixpkgs /nix /nix

ENV PATH=$PATH:/nix/var/nix/profiles/default/bin:/home/linuxbrew/.linuxbrew/bin \
  DEBIAN_FRONTEND=noninteractive \
  # NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
  LANG=en_US.UTF-8 \
  LANGUAGE=en_US.UTF-8 \
  LC_ALL=en_US.UTF-8 \
  LOCALE_ARCHIVE=/usr/lib/locale/locale-archive

RUN apt-get update -qq \
  && apt-get install -y -qq --no-install-recommends \
    ca-certificates locales tzdata sudo init systemd \
    openssh-server rsyslog cron \
    # xfce4 xfce4-goodies tightvncserver
  && apt purge -y --allow-remove-essential \
    # tar coreutils diffutils \
    sed xz-utils curl grep gzip git findutils \
  && apt-get autoremove -y \
  && locale-gen en_US.UTF-8

RUN curl -sSL https://get.docker.com/ | sh -s

COPY ./ /opt/dotbox/

RUN ansible-galaxy collection install community.general \
  && ansible-playbook -vvv /opt/dotbox/images/site.yaml \
  && rm -rf ~/.ansible

USER cicada

RUN curl -L https://nixos.org/nix/install | sh -s -- --no-daemon
RUN curl -sSf https://sh.rustup.rs | sh -s -- -y

USER root
ENTRYPOINT ["/opt/dotbox/images/script/entrypoint.sh"]
