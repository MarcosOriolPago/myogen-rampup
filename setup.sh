#!/usr/bin/env bash
# Clone myogen next to this script, make a virtual environment in .venv and install myogen into it (editable).
#   ./setup.sh                 (PYTHON=python3.12 ./setup.sh to pick the interpreter; needs Python >= 3.11)
set -euo pipefail
cd "$(dirname "$0")"

REPO=https://github.com/ETHRoboticsClub/myogen.git
PYTHON=${PYTHON:-python3}

if [ -d myogen/.git ]; then
    echo "myogen already cloned: pulling the latest version"
    git -C myogen pull --ff-only
else
    git clone "$REPO" myogen
fi

[ -d .venv ] || "$PYTHON" -m venv .venv
.venv/bin/python -m pip install --upgrade pip
# examples: matplotlib + Jupyter kernel + ipywidgets (live progress bars); viewer: mg.replay
(cd myogen && ../.venv/bin/python -m pip install -e ".[examples,viewer]")

echo
echo "done: activate with 'source .venv/bin/activate', then ./download_ninapro.sh and open rampup.ipynb"
