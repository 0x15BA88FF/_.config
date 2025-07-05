#!/usr/bin/bash

set -euo pipefail

# --- Package list

PACKAGES=(
    "jq"
    "fd"
    "ufw"
    "git"
    "fzf"
    "eza"
    "bat"
    "zsh"
    "tree"
    "curl"
    "btop"
    "tmux"
    "stow"
    "less"
    "yazi"
    "man-db"
    "neovim"
    "ripgrep"
    "tealdeer"
    "starship"
    "fastfetch"
    "brightnessctl"

    "docker"
    "gitleaks"
    "kanata-bin"
    "lua-language-server"

    "noto-fonts"
    "noto-fonts-cjk"
    "noto-fonts-emoji"
    "noto-fonts-extra"
    "ttf-jetbrains-mono-nerd"

    "sddm"
    "rofi"
    "alacritty"
    "rofimoji"
    "plymouth"
    "matugen-bin"
    "polkit-gnome"
    "gnome-clocks"
    "gnome-calculator"
    "gnome-text-editor"
    "libreoffice-still"

    "mpv"
    "mpc"
    "mpd-mpris"
    "ncmpcpp"
    "mpv-mpris"
    "pavucontrol"

    "tor"
    "aria2"
    "ngrok"
    "yt-dlp"
    "network-manager-applet"

    "rsync"
    "zathura"
    "tesseract"
    "zathura-cb"
    "zaread-git"
    "zathura-pdf-mupdf"
    "tesseract-data-eng"
)

paru -S --noconfirm "${PACKAGES[@]}"

# --- Install packages with script

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
sh <(curl https://raw.githubusercontent.com/0x15BA88FF/devault/refs/heads/main/scripts/install.sh)
