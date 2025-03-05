ARG CUDA_VERSION=12.3.2
ARG BASE_CUDA_DEV_CONTAINER=nvidia/cuda:${CUDA_VERSION}-devel-ubuntu22.04
ARG BASE_CUDA_RUN_CONTAINER=nvidia/cuda:${CUDA_VERSION}-runtime-ubuntu22.04

FROM ${BASE_CUDA_RUN_CONTAINER} AS runtime

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git   \
        curl  \
        unzip \
        openssh-client \
        ca-certificates \
        libgomp1 \
        sudo \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# setup user
RUN useradd --create-home --uid 5230 --user-group x \
  && echo "x:123456" | chpasswd \
  && usermod -aG sudo x \
  && echo "x ALL=(ALL:ALL) NOPASSWD:ALL" >>/etc/sudoers.d/nopasswd_user

RUN mkdir -p /data /opt && chown x:x -R /data /opt

USER x
WORKDIR /home/x
RUN curl -sSL -o tabby.tar.gz \
    https://github.com/TabbyML/tabby/releases/download/v0.25.1/tabby_x86_64-manylinux_2_28-cuda123.tar.gz \
  && mkdir -p /opt/tabby/bin \
  && tar -x --gunzip -f tabby.tar.gz -C /opt/tabby/bin --strip-components=1 \
  && rm -rf tabby.tar.gz

ENV PATH="$PATH:/opt/tabby/bin"
ENV TABBY_ROOT=/data
ENV RUST_BACKTRACE=1 COLORBT_SHOW_HIDDEN=1 RUST_BACKTRACE=full TABBY_DISABLE_USAGE_COLLECTION=1

ENTRYPOINT ["/opt/tabby/bin/tabby"]
