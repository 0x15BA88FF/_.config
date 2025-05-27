
#!/usr/bin/bash

set -euo pipefail

WAYLAND_PACKAGES=(
    "swww"
    "wtype"
    "waybar"
    "swaync"
    "swappy"
    "cliphist"
    "qt5-wayland"
    "qt6-wayland"
    "wf-recorder"
    "wl-clipboard"
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
)

install_packages() {
    local session_type="$1"

    case "$session_type" in
        wayland) paru -S --noconfirm "${WAYLAND_PACKAGES[@]}" ;;
        x11) paru -S --noconfirm "${X11_PACKAGES[@]}" ;;
    esac
}
