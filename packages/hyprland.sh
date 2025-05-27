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

install_packages "waybar"
paru -S --noconfirm "${PACKAGES[@]}"
