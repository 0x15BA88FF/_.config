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
    "vhs"
    "tree"
    "curl"
    "btop"
    "tmux"
    "stow"
    "less"
    "man-db"
    "neovim"
    "zoxide"
    "ripgrep"
    "tealdeer"
    "starship"
    "fastfetch"
    "brightnessctl"

    "go"
    "npm"
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
    "loupe"
    "ghostty"
    "obsidian"
    "chromium"
    "rofimoji"
    "nautilus"
    "plymouth"
    "matugen-bin"
    "polkit-gnome"
    "gnome-clocks"
    "zen-browser-bin"
    "python-pywalfox"
    "gnome-calculator"
    "gnome-text-editor"
    "libreoffice-still"

    "mpv"
    "mpd"
    "mpc"
    "ncmpcpp"
    "mpdris2"
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
