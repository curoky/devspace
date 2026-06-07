# syntax=docker/dockerfile:1.9.0
FROM ghcr.io/curoky/devspace:base-ubuntu26.04

USER root
RUN apt-get update -y \
  && apt-get install -y --no-install-recommends \
    task-xfce-desktop \
    dbus-x11 \
  && rm -rf /var/lib/apt/lists/*

USER root
ENTRYPOINT ["/opt/s6-overlay/init"]
