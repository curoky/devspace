FROM curoky/dotbox:base-ubuntu24.04

COPY --chown=1000:1000 --link --from=curoky/dotbox:stage-nixpkg /nix /nix
COPY --chown=1000:1000 --link --from=curoky/dotbox:stage-nixpkg /home/x/.local/state/nix /home/x/.local/state/nix
COPY --chown=1000:1000 --link --from=curoky/dotbox:stage-nixpkg /home/x/.local/state/nix /root/.local/state/nix
COPY --chown=1000:1000 --link --from=curoky/dotbox:stage-cache /tmp/pre-commit /tmp/pre-commit
COPY --chown=1000:1000 --link --from=curoky/dotbox:stage-conda /app/conda /app/conda
COPY --chown=1000:1000 --link --from=curoky/dotbox:stage-conda /app/pipx /app/pipx
COPY --chown=1000:1000 --link --from=curoky/dotbox:stage-prebuilt /output /app/prebuilt
COPY --chown=1000:1000 ./script/ /app/dotbox/docker/dist/default/script/

USER root
ENTRYPOINT ["/app/dotbox/docker/dist/default/script/entrypoint.sh"]
