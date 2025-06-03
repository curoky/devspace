# syntax=docker/dockerfile:1.9.0
FROM debian:bookworm-backports AS packer

RUN apt-get update -y \
  && apt-get install -y curl

# RUN curl -fsSL https://code-server.dev/install.sh | sh

# RUN mkdir -p ~/.vscode-server/extensions
# RUN code-server --extensions-dir ~/.vscode-server/extensions \
#     --install-extension ms-python.python

COPY install-vscode.sh .
RUN ./install-vscode.sh linux x64

COPY install-vscode-ext.sh .
RUN ./install-vscode-ext.sh

FROM debian:latest
COPY --from=packer /root/.vscode-server/extensions /opt/vscode/extensions
