# syntax=docker/dockerfile:1.9.0
FROM debian:bookworm-backports

RUN apt-get update -y \
  && apt-get install -y curl gcc g++ git pkg-config \
  # && curl -sSL -o /tmp/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
  && curl -sSL -o /tmp/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-py312_24.7.1-0-Linux-x86_64.sh \
  && bash /tmp/miniconda.sh -b -u -p /app/conda

ENV PATH=$PATH:/app/conda/condabin:/app/pipx/bin/

COPY env env
COPY setup-conda-env.sh /app/conda/condabin/setup-conda-env.sh
RUN setup-conda-env.sh env/py3.yaml \
  && setup-conda-env.sh env/profiling.yaml \
  # && setup-conda-env.sh env/py2.yaml \
  # && setup-conda-env.sh env/py311.yaml \
  && setup-conda-env.sh env/pipx.yaml

COPY pipx-install.sh /app/pipx/bin/pipx-install.sh
RUN pipx-install.sh \
    dotdrop licenseheaders
