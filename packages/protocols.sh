#!/usr/bin/bash

set -euo pipefail

WAYLAND_PACKAGES=(
    "swww"
    "grim"
    "slurp"
    "wtype"

    "wl-clipboard"
    "clipboard"

    "wf-recorder"

    "waybar"
    "swaync"
    "swappy"
    "qt5-wayland"
    "qt6-wayland"
    "xdg-desktop-portal"
    "xdg-desktop-portal-gtk"
    "xdg-desktop-portal-wlr"
)

X11_PACKAGES=(
    "feh"

    "xclip"
    "clipboard"

    "xcolor"
    "xdotool"
    "polybar"
    "xss-lock"
    "flameshot"
    "screencast"
)

session_type="$1"

case "$session_type" in
    wayland) paru -S --noconfirm "${WAYLAND_PACKAGES[@]}" ;;
    x11) paru -S --noconfirm "${X11_PACKAGES[@]}" ;;
esac
