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
RUN /opt/conda/bin/conda create -n py2 python=2 --yes \
  && /opt/conda/envs/py2/bin/pip install --no-cache-dir -r requirements-py2.txt \
  && /opt/conda/bin/conda create -n py3 python=3.11 -c conda-forge --yes \
  && /opt/conda/envs/py3/bin/pip install --no-cache-dir -r requirements-py3.txt \
  && /opt/conda/bin/conda create -n tf python=3.11 -c conda-forge --yes \
  && /opt/conda/envs/tf/bin/pip install --no-cache-dir -r requirements-ml.txt \
  && mkdir -p /opt/conda/envs/tf/etc/conda/activate.d \
  && echo 'export LD_LIBRARY_PATH=/opt/conda/envs/tf/lib/:/nix/var/nix/profiles/cuda11_8/lib:/opt/conda/envs/tf/lib/python3.11/site-packages/nvidia/cudnn/lib:$LD_LIBRARY_PATH' >> /opt/conda/envs/tf/etc/conda/activate.d/env_vars.sh \
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
ENV NIXPKGS_ALLOW_UNFREE=1 \
  NIXPKGS_ALLOW_BROKEN=1
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
    openssh-server rsyslog cron \
    gcc g++ gcc-11 g++-11 gcc-13 g++-13 \
    # xfce4 xfce4-goodies tightvncserver
  && apt-get autoremove -y \
  && locale-gen en_US.UTF-8 \
  && userdel ubuntu && rm -rf /home/ubuntu

# install docker
RUN curl -sSL https://get.docker.com/ | sh -s

# install nvidia
RUN curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/3bf863cc.pub | apt-key add - \
  && echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64 /" > /etc/apt/sources.list.d/cuda.list \
  && apt-get update \
  && apt-get install -y --no-install-recommends cuda-cudart-11-8 cuda-compat-11-8

# Note: g=u doesn't really work. https://github.com/moby/buildkit/issues/1951
COPY --chown=1000:1000 --chmod=g=u --from=nixpkgs /nix /nix
# COPY --chown=1000:1000 --chmod=g=u --from=vcpkg /opt/vcpkg /opt/vcpkg
COPY --chown=1000:1000 --chmod=g=u --from=homebrew /home/linuxbrew /home/linuxbrew
COPY --chown=1000:1000 --chmod=g=u --from=golang /root/go/bin /home/cicada/go/bin
COPY --chown=1000:1000 --chmod=g=u --from=conda /opt/conda /opt/conda
COPY --chown=1000:1000 --chmod=g=u ./ /opt/dotbox/

RUN ansible-galaxy collection install community.general \
  && ansible-playbook -vvv /opt/dotbox/images/site.yaml \
  && rm -rf ~/.ansible \
  && ln -s /nix/var/nix/profiles/default/bin/bazelisk /nix/var/nix/profiles/default/bin/bazel \
  && /opt/dotbox/images/script/setup-bazel-registry.sh \
  && /opt/dotbox/images/script/setup-gcc-as-default.sh \
  && /opt/dotbox/images/script/setup-dotfiles.sh \
  && mkdir /data \
  && chown cicada:cicada /data /opt

USER cicada

# install nixpkg
RUN curl -L https://nixos.org/nix/install | sh -s -- --no-daemon

# install rust
# RUN curl -sSf https://sh.rustup.rs | sh -s -- -y

# install conan
RUN pipx install conan==1.60.1 \
  && pipx install licenseheaders

RUN /opt/dotbox/images/script/setup-dotfiles.sh

USER root
ENTRYPOINT ["/opt/dotbox/images/script/entrypoint.sh"]
