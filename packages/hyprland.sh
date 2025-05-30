#!/usr/bin/bash

source ./dps.sh
set -euo pipefail

# --- Package list

PACKAGES=(
    "hyprland"
    "hyprlock"
    "hyprshader"
    "hypridle-git"
    "hyprpicker-git"
    "xdg-desktop-portal-hyprland"
)

sh ./protocols.sh "wayland"
paru -S --noconfirm "${PACKAGES[@]}"
