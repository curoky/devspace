FROM debian:bookworm-backports

RUN apt-get update -y \
  && apt-get install -y curl gcc g++ git pkg-config \
    libglib2.0-dev libgirepository1.0-dev libcairo2-dev \
  && curl -sSL -o /tmp/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
  && bash /tmp/miniconda.sh -b -u -p /app/conda

COPY env env
COPY setup-conda-env.sh setup-conda-env.sh
RUN ./setup-conda-env.sh env/py2.yaml \
  && ./setup-conda-env.sh env/py3.yaml \
  && ./setup-conda-env.sh env/py311.yaml \
  && ./setup-conda-env.sh env/pipx.yaml

COPY pipx-install.sh pipx-install.sh
RUN ./pipx-install.sh \
    licenseheaders dotdrop netron
