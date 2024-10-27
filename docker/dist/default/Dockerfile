# syntax=docker/dockerfile:1.9.0
FROM curoky/dotbox:base-debian11

COPY --chown=x:x --link --from=curoky/dotbox:stage-nixpkg /nix /nix
COPY --chown=x:x --link --from=curoky/dotbox:stage-nixpkg /home/x/.local/state/nix /home/x/.local/state/nix
COPY --chown=x:x --link --from=curoky/dotbox:stage-conda /app/conda /app/conda
COPY --chown=x:x --link --from=curoky/dotbox:stage-conda /app/pipx /app/pipx

USER root
ENTRYPOINT ["/app/dotbox/docker/base/script/entrypoint.sh"]
