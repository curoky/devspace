# syntax=docker/dockerfile:1.9.0
ARG BASE_IMAGE=debian:12

FROM $BASE_IMAGE

ENV PATH=$PATH:/home/x/app/pipx/bin:/home/x/app/prebuilt/bin:/nix/var/nix/profiles/default/bin \
  DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && apt-get install -y sudo curl

RUN curl -sSL -o prebuilt-sre-tools.linux-x86_64.gzip.sh https://github.com/curoky/dotbox/releases/download/v1.0/prebuilt-sre-tools.linux-x86_64.gzip.sh \
  && bash prebuilt-sre-tools.linux-x86_64.gzip.sh \
  && rm -rf prebuilt-sre-tools.linux-x86_64.gzip.sh

COPY --chown=5230:5230 ./ /home/x/app/dotbox

RUN ln -sf /home/x/app/dotbox ~/dotbox \
  && ln -s /home/x/app/prebuilt ~/prebuilt \
  && ln -s /home/x/app/prebuilt /app/prebuilt \
  && ln -s /home/x/app/prebuilt/pkgs/zsh/bin/zsh /usr/bin \
  && ln -s /home/x/app/prebuilt/pkgs/wget/bin/wget /usr/bin \
  && /home/x/app/dotbox/docker/base/script/setup-sysconf.sh ~/dotbox/config \
  && /home/x/app/dotbox/config/setup.sh docker ~/dotbox/config \
  && mkdir -p /workspace \
  && chown x:x /workspace /app /opt

COPY --chown=5230:5230 --link --from=curoky/dotbox:stage-conda /home/x/app/conda /home/x/app/conda
COPY --chown=5230:5230 --link --from=curoky/dotbox:stage-conda /home/x/app/pipx /home/x/app/pipx
COPY --chown=5230:5230 --link --from=curoky/dotbox:stage-nixpkg /nix /nix
COPY --chown=5230:5230 --link --from=curoky/dotbox:stage-nixpkg /home/x/.local/state/nix /home/x/.local/state/nix

USER x
RUN ln -s /home/x/app/dotbox ~/dotbox \
  && ln -s /home/x/app/prebuilt ~/prebuilt \
  && ln -s ~/.local/state/nix/profiles/profile ~/.nix-profile \
  && mkdir ~/.nix-defexpr \
  && ln -s ~/.local/state/nix/profiles/channels ~/.nix-defexpr/channels \
  && /home/x/app/dotbox/config/setup.sh docker ~/dotbox/config

USER root
ENTRYPOINT ["/home/x/app/dotbox/docker/base/script/entrypoint.sh"]
