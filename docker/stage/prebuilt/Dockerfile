# syntax=docker/dockerfile:1.9.0
FROM debian:bookworm-backports AS packer

RUN apt-get update -y && apt-get install -y rsync curl file binutils less vim # python3 python3-pip

COPY --from=curoky/dotbox:stage-prebuilt-base /output /output/base
COPY --from=curoky/dotbox:stage-prebuilt-llvm18 /output /output-llvm18
COPY --from=curoky/dotbox:stage-prebuilt-rust /output /output-rust
COPY --from=curoky/dotbox:stage-prebuilt-perl /output /output-perl
COPY --from=curoky/dotbox:stage-prebuilt-go /output /output-go
COPY --from=curoky/dotbox:stage-prebuilt-py3 /output /output-py3
COPY --from=curoky/dotbox:stage-prebuilt-haskell /output /output-haskell

RUN rsync --progress --archive --human-readable /output-base/ /output/ \
  && rsync --progress --archive --human-readable /output-llvm18/ /output/ \
  && rsync --progress --archive --human-readable /output-rust/ /output/ \
  && rsync --progress --archive --human-readable /output-perl/ /output/ \
  && rsync --progress --archive --human-readable /output-go/ /output/ \
  && rsync --progress --archive --human-readable /output-py3/ /output/ \
  && rsync --progress --archive --human-readable /output-haskell/ /output/

COPY wrapper/* /output/bin/
COPY patch.sh .
RUN ./patch.sh \
  && chown 1000:1000 -R /output \
  && mkdir -p /output/dotbox \
  && curl -sSL https://github.com/curoky/dotbox/archive/refs/heads/dev.tar.gz \
    | tar -xv --gunzip -C /output/dotbox --strip-components 1 \
  && curl -sSL -o /output/share/tmux.conf https://raw.githubusercontent.com/gpakosz/.tmux/5f1047550ba2ba16a27bf8c9ea958fbbf974598d/.tmux.conf

FROM debian:bookworm-slim
COPY --from=packer /output /output
