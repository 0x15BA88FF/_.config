#!/usr/bin/env bash
set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_CONFIG="$REPO_DIR/configuration/home"
ROOT_CONFIG="$REPO_DIR/configuration/root"

sh ./packages/core.sh
sh ./packages/base.sh
sh ./packages/play.sh

echo "Select a window manager:"
echo "1) i3"
echo "2) Hyprland"

case $choice in
  1) sh ./packages/i3.sh ;;
  2) sh ./packages/hyprland.sh ;;
  *) echo "Invalid option." ;;
esac


stow_packages() {
    local config_dir="$1"
    local target_dir="$2"

    for pkg in "$config_dir"/*; do
        [ -d "$pkg" ] && stow --dotfiles --target "$target_dir" --dir "$config_dir" --restow "$(basename "$pkg")"
    done
}

if [ "$EUID" -eq 0 ]; then
    echo "Running as root — skipping user dotfiles installation."
    echo "Installing root dotfiles..."
    stow_packages "$ROOT_CONFIG" /
else
    echo "Installing home dotfiles..."
    stow_packages "$HOME_CONFIG" "$HOME"

    echo "Installing root dotfiles with sudo..."
    sudo bash -c "$(declare -f stow_packages); stow_packages '$ROOT_CONFIG' '/'"
fi
