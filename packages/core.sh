#!/usr/bin/bash

set -euo pipefail

# --- AUR Helper (Paru)

if ! command -v paru &>/dev/null; then
    sudo pacman -S --needed --noconfirm git base-devel
    git clone https://aur.archlinux.org/paru.git /tmp/paru
    pushd /tmp/paru >/dev/null
    makepkg -si --noconfirm
    popd >/dev/null
    rm -rf /tmp/paru
fi

# --- Package list

PACKAGES=(
    "git"
    "grub"
    "base-devel"

    "pipewire"
    "wireplumber"
    "pipewire-alsa"
    "pipewire-jack"
    "pipewire-audio"
    "pipewire-pulse"
    "gst-plugin-pipewire"
    "sof-firmware"
    "rtkit"

    "networkmanager"

    "downgrade"
    "paccache-hook"
)

paru -S --needed --noconfirm "${PACKAGES[@]}"
