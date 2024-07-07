FROM curoky/dotbox:ubuntu24.04-minimal

USER root
## Setup gcc
RUN apt-get update -y \
  && apt-get install -y --no-install-recommends \
    gcc-13 g++-13

USER x
ENV PATH="$PATH:/home/x/.nix-profile/bin"

COPY config config
## Setup tools from nixpkgs
RUN nix-env -p /nix/var/nix/profiles/tf-gpu -iA \
    nixpkgs.bazelisk \
  && nix-env -p /nix/var/nix/profiles/tf-gpu -iA -f /app/dotbox/third-party/nixpkgs/default.nix nsight-systems \
  && /app/dotbox/docker/minimal/script/setup-conda-env.sh config/conda_env/tf2.16.yaml
