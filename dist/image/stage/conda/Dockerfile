# syntax=docker/dockerfile:1.9.0
FROM debian:stable-slim

RUN apt-get update -y \
  && apt-get install -y curl gcc g++ git pkg-config \
  # && curl -sSL -o /tmp/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
  && curl -sSL -o /tmp/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-py312_24.11.1-0-Linux-x86_64.sh \
  && bash /tmp/miniconda.sh -b -u -p /opt/conda

ENV PATH=$PATH:/opt/conda/condabin:/opt/conda/pipx/bin/

COPY env env
COPY setup-conda-env.sh /opt/conda/condabin/setup-conda-env.sh
COPY lock-conda-env.sh /opt/conda/condabin/lock-conda-env.sh
RUN setup-conda-env.sh -x -e env/py3-lock.yaml
  # && setup-conda-env.sh -x -e env/profiling.yaml
  # && setup-conda-env.sh -x -e env/py2.yaml \
  # && setup-conda-env.sh -x -e env/py311.yaml \
  # && setup-conda-env.sh -x -e env/pipx.yaml

# COPY pipx-install.sh /opt/conda/pipx/bin/pipx-install.sh
# RUN /opt/conda/bin/pip3 install pipx \
#   && pipx-install.sh \
#     licenseheaders conan
