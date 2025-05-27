#!/usr/bin/bash

source ./dps.sh
set -euo pipefail

# --- Package list

PACKAGES=(
    "i3"
    "i3-lock"
)

install_packages "x11"
paru -S --noconfirm "${PACKAGES[@]}"
