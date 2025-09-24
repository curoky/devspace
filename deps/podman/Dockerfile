FROM debian:stretch-backports AS debian-default

RUN cat /etc/apt/sources.list \
  && sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list \
  && sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list.d/backports.list \
  && sed -i 's/security.debian.org/archive.debian.org/g' /etc/apt/sources.list \
  && sed -i '/stretch-updates/d' /etc/apt/sources.list \
  && apt-get update -y

FROM nixpkgs/nix-unstable:latest AS deps-nixpkgs-builder

ENV NIX_PATH=nixpkgs=channel:nixos-25.05

RUN nix-channel --add https://nixos.org/channels/nixos-25.05 nixpkgs \
  && nix-channel --update
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.netavark
RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.patchelf
# RUN nix-env -p /nix/var/nix/profiles/libgpg-error -iA nixpkgs.pkgsStatic.libgpg-error.dev
# RUN nix-env -p /nix/var/nix/profiles/libassuan -iA nixpkgs.pkgsStatic.libassuan.dev
# RUN nix-env -p /nix/var/nix/profiles/libseccomp -iA nixpkgs.pkgsStatic.libseccomp.dev
# RUN nix-env -p /nix/var/nix/profiles/default -iA nixpkgs.pkgsStatic.gpgme

RUN mkdir -p /opt/tools/bin \
  && cp -L /nix/var/nix/profiles/default/bin/netavark /opt/tools/bin/ \
  && cp -L /nix/var/nix/profiles/default/bin/patchelf /opt/tools/bin

FROM debian-default AS deps-builder

RUN apt-get update -y \
  && apt-get install -y \
      git curl wget vim ca-certificates unzip xz-utils \
      pkg-config make gcc g++ gperf

ENV PATH=$PATH:/opt/deps/bin
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/deps/lib

RUN mkdir -p /opt/build/libgpg-error \
  && curl -sSL https://www.gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.46.tar.gz | \
    tar -x --gunzip -C /opt/build/libgpg-error --strip-components 1 \
  && cd /opt/build/libgpg-error \
  && ./configure --prefix=/opt/deps \
  && make -j$(nproc) && make install

RUN mkdir -p /opt/build/libgcrypt \
  && curl -sSL https://gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.10.3.tar.gz | \
    tar -x --gunzip -C /opt/build/libgcrypt --strip-components 1 \
  && cd /opt/build/libgcrypt \
  && ./configure --prefix=/opt/deps \
  && make -j$(nproc) && make install

RUN mkdir -p /opt/build/libksba \
  && curl -sSL https://gnupg.org/ftp/gcrypt/libksba/libksba-1.6.6.tar.bz2 | \
    tar -x --bzip2 -C /opt/build/libksba --strip-components 1 \
  && cd /opt/build/libksba \
  && ./configure --prefix=/opt/deps \
  && make -j$(nproc) && make install

RUN mkdir -p /opt/build/npth \
  && curl -sSL https://gnupg.org/ftp/gcrypt/npth/npth-1.6.tar.bz2 | \
    tar -x --bzip2 -C /opt/build/npth --strip-components 1 \
  && cd /opt/build/npth \
  && ./configure --prefix=/opt/deps \
  && make -j$(nproc) && make install

RUN mkdir -p /opt/build/libassuan \
  && curl -sSL https://gnupg.org/ftp/gcrypt/libassuan/libassuan-2.5.6.tar.bz2 | \
    tar -x --bzip2 -C /opt/build/libassuan --strip-components 1 \
  && cd /opt/build/libassuan \
  && ./configure --prefix=/opt/deps \
  && make -j$(nproc) && make install

RUN mkdir -p /opt/build/gnupg \
  && curl -sSL https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.4.5.tar.bz2 | \
    tar -x --bzip2 -C /opt/build/gnupg --strip-components 1 \
  && cd /opt/build/gnupg \
  && ./configure --prefix=/opt/deps \
    --with-npth-prefix=/opt/deps \
    # --with-libgpg-error-prefix=/opt/deps \
    # --with-libgcrypt-prefix=/opt/deps \
    # --with-ksba-prefix=/opt/deps \
    # --with-npth-prefix=/opt/deps \
  && make -j$(nproc) && make install

RUN mkdir -p /opt/build/gpgme \
  && curl -sSL https://gnupg.org/ftp/gcrypt/gpgme/gpgme-1.23.2.tar.bz2 | \
    tar -x --bzip2 -C /opt/build/gpgme --strip-components 1 \
  && cd /opt/build/gpgme \
  && ./configure --prefix=/opt/deps \
  && make -j$(nproc) && make install

RUN mkdir -p /opt/build/libseccomp \
  && curl -sSL https://github.com/seccomp/libseccomp/releases/download/v2.5.5/libseccomp-2.5.5.tar.gz | \
    tar -x --gunzip -C /opt/build/libseccomp --strip-components 1 \
  && cd /opt/build/libseccomp \
  && ./configure --prefix=/opt/deps \
  && make -j$(nproc) && make install

FROM debian-default as podman-builder

RUN apt-get update -y \
  && apt-get install -y \
      git curl wget vim ca-certificates unzip xz-utils \
      pkg-config make gcc g++

RUN mkdir -p /usr/local/go \
  && curl -sSL https://go.dev/dl/go1.25.1.linux-amd64.tar.gz | \
    tar -x --gunzip -C /usr/local/go --strip-components 1

COPY --from=deps-builder /opt/deps /opt/deps

WORKDIR /src

ENV GOPATH=/go
ENV PATH="/usr/local/go/bin:$PATH:$GOPATH/bin"
ENV PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/opt/deps/lib/pkgconfig

RUN git clone --depth 1 --branch v5.6.1 https://github.com/containers/podman.git

WORKDIR /src/podman
RUN make vendor \
  && make bin/podman bin/rootlessport bin/quadlet podman-remote


FROM debian-default

RUN apt-get update -y \
  && apt-get install -y \
    curl

COPY --from=deps-nixpkgs-builder /opt/tools /opt/tools
COPY --from=deps-builder /opt/deps /opt/deps
COPY --from=podman-builder /src/podman /src/podman

RUN mkdir -p /opt/podman/bin /opt/podman/lib  \
  && cp /src/podman/bin/podman /opt/podman/bin/_podman \
  && cp /src/podman/bin/podman-remote /opt/podman/bin/_podman-remote \
  && cp /opt/deps/lib/libgpgme.so.11 \
    /opt/deps/lib/libseccomp.so.2 \
    /opt/deps/lib/libassuan.so.0 \
    /opt/deps/lib/libgpg-error.so.0 \
    /opt/podman/lib \
  && /opt/tools/bin/patchelf --add-rpath '$ORIGIN/../lib' /opt/podman/bin/_podman

RUN cp /opt/tools/bin/* /opt/podman/bin

RUN curl -sSL -o /opt/podman/bin/conmon https://github.com/containers/conmon/releases/download/v2.1.13/conmon.amd64 \
  && chmod +x /opt/podman/bin/conmon

RUN mkdir -p /opt/podman/gpu \
  && curl -sSL -o /opt/podman/gpu/libnvidia-container1_1.17.5-1_amd64.deb https://github.com/NVIDIA/libnvidia-container/raw/gh-pages/stable/deb/amd64/libnvidia-container1_1.17.5-1_amd64.deb \
  && curl -sSL -o /opt/podman/gpu/libnvidia-container-tools_1.17.5-1_amd64.deb https://github.com/NVIDIA/libnvidia-container/raw/gh-pages/stable/deb/amd64/libnvidia-container-tools_1.17.5-1_amd64.deb \
  && curl -sSL -o /opt/podman/gpu/nvidia-container-toolkit-base_1.17.5-1_amd64.deb https://github.com/NVIDIA/libnvidia-container/raw/gh-pages/stable/deb/amd64/nvidia-container-toolkit-base_1.17.5-1_amd64.deb \
  && curl -sSL -o /opt/podman/gpu/nvidia-container-toolkit_1.17.5-1_amd64.deb https://github.com/NVIDIA/libnvidia-container/raw/gh-pages/stable/deb/amd64/nvidia-container-toolkit_1.17.5-1_amd64.deb

RUN mkdir -p /opt/podman/tmpdir

COPY ./install.sh /opt/podman/
COPY ./conf/* /opt/podman/conf/
COPY ./bin/* /opt/podman/bin/

RUN ln -s -r /opt/podman/bin/podman /opt/podman/bin/pod
RUN ln -s -r /opt/podman/bin/podman /opt/podman/bin/docker
