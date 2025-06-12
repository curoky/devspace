#!/usr/bin/env bash
set -xeuo pipefail

export save_path=$1
conda env list | awk '{print $1}' | while read env; do
  if [[ $env == "base" || $env == "" || $env == "#"* ]]; then
    continue
  fi
  echo "Exporting environment: $env"
  conda env export -n "$env" >"$save_path/${env}.yml"
done
