#!/usr/bin/bash

set -euo pipefail

# --- Package list

PACKAGES=(
    "i3"
    "i3-lock"
)

sh ./protocols.sh "x11"
paru -S --noconfirm "${PACKAGES[@]}"
