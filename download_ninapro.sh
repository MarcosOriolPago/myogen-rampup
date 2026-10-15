#!/usr/bin/env bash
# Download NinaPro DB5 (two Myo armbands + CyberGlove, 10 intact subjects) into data/ninapro_db5/sN/.
#   ./download_ninapro.sh            subject 1 (~20 MB, enough for the notebook)
#   ./download_ninapro.sh 1 2 3      several subjects;  ./download_ninapro.sh all   all ten (~200 MB)
# Source: https://ninapro.hevs.ch/instructions/DB5.html  (cite the NinaPro DB5 paper if you use the data)
set -euo pipefail
cd "$(dirname "$0")"

URL=https://ninapro.hevs.ch/files/DB5_Preproc
OUT=data/ninapro_db5
subjects=("$@")
[ ${#subjects[@]} -eq 0 ] && subjects=(1)
[ "${subjects[0]}" = all ] && subjects=(1 2 3 4 5 6 7 8 9 10)

mkdir -p "$OUT"
for s in "${subjects[@]}"; do
    if ls "$OUT/s$s"/*.mat >/dev/null 2>&1; then
        echo "s$s: already downloaded"
        continue
    fi
    echo "s$s: downloading"
    tmp=$(mktemp -d)
    curl -fL --retry 3 -o "$tmp/s$s.zip" "$URL/s$s.zip"
    unzip -q "$tmp/s$s.zip" -d "$tmp"
    mkdir -p "$OUT/s$s"
    find "$tmp" -name "*.mat" -exec mv {} "$OUT/s$s/" \;    # flatten whatever folder the zip uses
    rm -rf "$tmp"
    ls "$OUT/s$s"
done
