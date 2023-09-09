ENV_PATHS=(
  "$WORKSPACE/thrift-toolbox"
)

for p in "${ENV_PATHS[@]}"; do
  [[ -d $p ]] && export PYTHONPATH=$p:$PYTHONPATH
done
