FROM debian:bookworm-backports as stage_conda

RUN apt-get update -y \
  && apt-get install -y curl gcc g++ git \
  && curl -sSL -o /tmp/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
  && bash /tmp/miniconda.sh -b -u -p /app/conda

COPY env env
COPY setup-conda-env.sh setup-conda-env.sh
RUN ./setup-conda-env.sh env/py2.yaml \
  && ./setup-conda-env.sh env/py3.yaml \
  && ./setup-conda-env.sh env/pipx.yaml

ENV PIPX_HOME=/app/pipx \
  PIPX_BIN_DIR=/app/pipx/bin \
  PIPX_MAN_DIR=/app/pipx/share/man
RUN ls -la /app/conda/envs/pipx/bin/ \
  && /app/conda/envs/pipx/bin/pipx install licenseheaders dotdrop
