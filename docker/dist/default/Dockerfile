# syntax=docker/dockerfile:1.9.0
FROM curoky/dotbox:base-ubuntu24.04

COPY --chown=5230:5230 --link --from=curoky/dotbox:stage-nixpkg /nix /nix
COPY --chown=5230:5230 --link --from=curoky/dotbox:stage-nixpkg /home/x/.local/state/nix /home/x/.local/state/nix
COPY --chown=5230:5230 --link --from=curoky/dotbox:stage-conda /app/conda /app/conda
COPY --chown=5230:5230 --link --from=curoky/dotbox:stage-conda /app/pipx /app/pipx
COPY --chown=5230:5230 --link --from=curoky/dotbox:stage-prebuilt /output /app/prebuilt
COPY --chown=5230:5230 ./script/ /app/dotbox/docker/dist/default/script/

USER root
ENTRYPOINT ["/app/dotbox/docker/dist/default/script/entrypoint.sh"]
