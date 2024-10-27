# syntax=docker/dockerfile:1.9.0
FROM python:3.12

COPY --from=curoky/dotbox:base-debian11 /app/dotbox /app/dotbox

ENV PRE_COMMIT_HOME=/tmp/pre-commit

RUN apt-get update -y \
  && apt-get install -y git

RUN pip install pre-commit

RUN cd /app/dotbox \
  && git config --global --add safe.directory /app/dotbox \
  && pre-commit install-hooks \
  && pre-commit autoupdate \
  && pre-commit install-hooks
