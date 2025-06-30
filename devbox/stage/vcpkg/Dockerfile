FROM curoky/dotbox:stage_nixpkg
LABEL org.opencontainers.image.authors="cccuroky@gmail.com"

RUN sudo mkdir -p /opt/vcpkg && sudo chown 5230:5230 -R /app \
  && git clone https://github.com/microsoft/vcpkg /opt/vcpkg \
  && cd /opt/vcpkg \
  && ./bootstrap-vcpkg.sh -disableMetrics
