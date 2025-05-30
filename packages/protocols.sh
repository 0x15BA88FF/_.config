#!/usr/bin/bash

set -euo pipefail

WAYLAND_PACKAGES=(
    "swww"
    "grim"
    "slurp"
    "wtype"
    "cliphist"
    "wf-recorder"

    "waybar"
    "swaync"
    "swappy"
    "wl-clipboard"
    "qt5-wayland"
    "qt6-wayland"
    "xdg-desktop-portal"
    "xdg-desktop-portal-gtk"
    "xdg-desktop-portal-wlr"
)

X_PACKAGES=(
    "feh"
    "xsel"
    "xcolor"
    "xdotool"
    "polybar"
    "clipmenu"
    "xss-lock"
    "flameshot"
    "screencast"
)

session_type="$1"

case "$session_type" in
    wayland) paru -S --noconfirm "${WAYLAND_PACKAGES[@]}" ;;
    x11) paru -S --noconfirm "${X11_PACKAGES[@]}" ;;
esac
