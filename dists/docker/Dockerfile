FROM homebrew/brew:latest as homebrew
COPY images/script/setup-pkg-brew.sh setup-pkg-brew.sh
COPY images/config/brew/Brewfile.linux Brewfile.linux
ENV HOMEBREW_NO_ANALYTICS=1 \
  HOMEBREW_INSTALL_FROM_API=1
RUN rm -rf /home/linuxbrew/.linuxbrew/Homebrew/Library/Taps/homebrew/homebrew-core \
  && ./setup-pkg-brew.sh Brewfile.linux \
  && rm -rf "$(brew --cache)"

FROM ghcr.io/conda/conda-ci:main-linux-python3.11 as conda
USER root
COPY images/config/pip/*.txt .
COPY images/script/setup-pkg-py.sh .
RUN apt-get -y update && apt-get install -y procps libsnappy-dev \
  && ./setup-pkg-py.sh .

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
ENV NIXPKGS_ALLOW_UNFREE=1 \
  NIXPKGS_ALLOW_BROKEN=1
COPY pkgs/nix pkgs/nix
COPY default.nix default.nix
COPY images/script/setup-pkg-nix.sh setup-pkg-nix.sh
RUN nix-channel --update \
  && ./setup-pkg-nix.sh

FROM ubuntu:23.04
LABEL org.opencontainers.image.authors="cccuroky@gmail.com"

ENV PATH=$PATH:/nix/var/nix/profiles/default/bin:/home/linuxbrew/.linuxbrew/bin \
  DEBIAN_FRONTEND=noninteractive \
  # NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
  LANG=en_US.UTF-8 \
  LANGUAGE=en_US.UTF-8 \
  LC_ALL=en_US.UTF-8 \
  LOCALE_ARCHIVE=/usr/lib/locale/locale-archive

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    curl gnupg2 ca-certificates locales tzdata sudo init systemd \
    openssh-server rsyslog cron lsb-release \
    gcc-11 g++-11 libsnappy-dev \
    # xfce4 xfce4-goodies tightvncserver
  && apt-get autoremove -y \
  && locale-gen en_US.UTF-8 \
  && userdel ubuntu && rm -rf /home/ubuntu

# Note: g=u doesn't really work. https://github.com/moby/buildkit/issues/1951
COPY --chown=1000:1000 --chmod=g=u --from=nixpkgs /nix /nix
# COPY --chown=1000:1000 --chmod=g=u --from=vcpkg /opt/vcpkg /opt/vcpkg
COPY --chown=1000:1000 --chmod=g=u --from=homebrew /home/linuxbrew /home/linuxbrew
COPY --chown=1000:1000 --chmod=g=u --from=golang /root/go/bin /home/cicada/go/bin
COPY --chown=1000:1000 --chmod=g=u --from=conda /opt/conda /opt/conda
COPY --chown=1000:1000 --chmod=g=u ./ /opt/dotbox
COPY --chown=1000:1000 --chmod=g=u ./ /home/cicada/dotbox
COPY --chown=root:adm --chmod=g=u ./ /root/dotbox

RUN ansible-galaxy collection install community.general \
  && ansible-playbook -vvv /opt/dotbox/images/site.yaml \
  && rm -rf ~/.ansible \
  && ln -s /nix/var/nix/profiles/default/bin/bazelisk /nix/var/nix/profiles/default/bin/bazel \
  && /opt/dotbox/images/script/setup-bazel-registry.sh \
  && /opt/dotbox/images/script/setup-gcc-as-default.sh \
  && /opt/dotbox/images/script/setup-cuda.sh \
  && dotdrop install --cfg=~/dotbox/config.yaml --force --profile=devbox-sysconf \
  && dotdrop install --cfg=~/dotbox/config.yaml --force --profile=devbox-userconf-outofbox \
  && mkdir /data \
  && chown cicada:cicada /data /opt

USER cicada

RUN git -C ~/dotbox remote set-url origin git@github.com:curoky/dotbox \
  && dotdrop install --cfg=~/dotbox/config.yaml --force --profile=devbox-userconf-base \
  && curl -L https://nixos.org/nix/install | sh -s -- --no-daemon \
  && pipx install conan==1.60.1 \
  && pipx install licenseheaders

USER root
ENTRYPOINT ["/opt/dotbox/images/script/entrypoint.sh"]
