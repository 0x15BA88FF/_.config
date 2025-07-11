#!/usr/bin/env bash
set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_CONFIG="$REPO_DIR/configuration/home"
ROOT_CONFIG="$REPO_DIR/configuration/root"

install_packages() {
    echo "Installing packages..."
    sh ./packages/core.sh
    sh ./packages/base.sh
    sh ./packages/play.sh

    echo "Select a window manager:"
    echo "1) i3"
    echo "2) Hyprland"
    read -p "Enter your choice (1-2): " choice

    case $choice in
        1) sh ./packages/i3.sh ;;
        2) sh ./packages/hyprland.sh ;;
        *) echo "Invalid option." ;;
    esac
}

stow_packages() {
    local config_dir="$1"
    local target_dir="$2"

    cd "$config_dir"

    for pkg in "$config_dir"/*; do
        [ -d "$pkg" ] && stow --dotfiles --target "$target_dir" --stow "$(basename "$pkg")"
    done
}

install_dotfiles() {
    echo "Installing dotfiles..."

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
}

main() {
    echo "What would you like to do?"
    echo "1) Install packages and dotfiles"
    echo "2) Install packages only"
    echo "3) Install dotfiles only"
    read -p "Enter your choice (1-3): " main_choice

    case $main_choice in
        1)
            install_packages
            install_dotfiles
            ;;
        2)
            install_packages
            ;;
        3)
            install_dotfiles
            ;;
        *)
            echo "Invalid option."
            exit 1
            ;;
    esac
}

main
