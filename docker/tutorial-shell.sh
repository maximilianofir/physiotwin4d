#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "$0")/.." && pwd)
cache_dir="$repo_root/.cache/physiotwin4d"
container_root="/workspace/physiotwin4d"

mkdir -p "$cache_dir/home" "$repo_root/tutorials/network_weights" \
    "$repo_root/tutorials/output"

if [[ ! -t 0 || ! -t 1 ]]; then
    echo "docker/tutorial-shell.sh requires an interactive terminal." >&2
    exit 1
fi

echo "Opening the PhysioTwin4D tutorial shell in $container_root"
echo "Run a lesson with: python tutorials/<tutorial_script>.py"

exec docker run --rm -it --gpus all --shm-size=8g \
    --user "$(id -u):$(id -g)" \
    --volume "$repo_root:$container_root" \
    --volume "$cache_dir:/cache" \
    --workdir "$container_root" \
    --env HOME=/cache/home \
    --env HF_HOME=/cache/huggingface \
    --env HF_HUB_OFFLINE=1 \
    --env LOGNAME=physiotwin4d \
    --env PYTHONPATH="$container_root/src" \
    --env TOTALSEG_HOME_DIR=/cache/totalsegmentator \
    --env USER=physiotwin4d \
    --env MPLCONFIGDIR=/tmp/matplotlib \
    --env OMNI_KIT_ACCEPT_EULA=YES \
    --env 'PS1=physiotwin4d:\w$ ' \
    physiotwin4d:tutorials bash --noprofile --norc
