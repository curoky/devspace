FROM curoky/dotbox:stage_nixpkg
LABEL org.opencontainers.image.authors="cccuroky@gmail.com"

RUN sudo mkdir -p /home/x/app/vcpkg && sudo chown 5230:5230 -R /app \
  && git clone https://github.com/microsoft/vcpkg /home/x/app/vcpkg \
  && cd /home/x/app/vcpkg \
  && ./bootstrap-vcpkg.sh -disableMetrics
