#!/usr/bin/bash

set -euo pipefail

# --- Package list

PACKAGES=(
    "dex"
    "feh"
    "xsel"
    "xcolor"
    "xdotool"
    "polybar"
    "clipmenu"
    "xss-lock"
)

paru -S --noconfirm "${PACKAGES[@]}"
