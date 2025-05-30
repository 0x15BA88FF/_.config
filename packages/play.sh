#!/usr/bin/bash

set -euo pipefail

# --- Install packages with script

curl -fsS https://dotenvx.sh | sudo sh
curl -L https://coder.com/install.sh | sh

# --- Package list

PACKAGES=(
    "yazi"
    "direnv"
    "picard"
    "pitivi"
    "discord"
    "newsboat"
    "httpie-desktop-bin"
)

paru -S --noconfirm "${PACKAGES[@]}"
