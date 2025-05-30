#!/usr/bin/bash

source ./dps.sh
set -euo pipefail

# --- Package list

PACKAGES=(
    "i3"
    "i3-lock"
)

sh ./protocols.sh "wayland"
paru -S --noconfirm "${PACKAGES[@]}"
