FROM ubuntu:24.04

RUN apt-get update \
  && apt-get remove --allow-remove-essential -y curl grep gzip findutils procps \
    ncurses-bin ncurses-base libncursesw6 \
  && apt-get install -y --no-install-recommends \
    sudo systemd \
  && apt-get autoremove -y \
  # update user
  && userdel ubuntu -r \
