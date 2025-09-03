#!/usr/bin/bash

if ! command -v paru &>/dev/null; then
    sudo pacman -S --needed --noconfirm git base-devel
    git clone https://aur.archlinux.org/paru.git /tmp/paru
    pushd /tmp/paru >/dev/null
    makepkg -si --noconfirm
    popd >/dev/null
    rm -rf /tmp/paru
fi

CORE=(
    "ufw"
    "rtkit"
    "pipewire"
    "wireplumber"
    "sof-firmware"
    "pipewire-alsa"
    "pipewire-jack"
    "pipewire-audio"
    "pipewire-pulse"
    "gst-plugin-pipewire"

    # "bluez"
    "networkmanager"

    "downgrade"
    "paccache-hook"
    "pacman-contrib"
)

BASE=(
    "jq"
    "fd"
    "git"
    "fzf"
    "eza"
    # "bat"
    "zsh"
    "tree"
    # "wget"
    "curl"
    "btop"
    "tmux"
    "stow"
    "less"
    "yazi"
    "7zip"
    "man-db"
    "neovim"
    "ripgrep"
    "tealdeer"
    "starship"
    "fastfetch"
    "brightnessctl"

    "pandoc"
    "texlive-full"
    "docker"
    # "gitleaks"
    "kanata-bin"
    "lua-language-server"

    "noto-fonts"
    "noto-fonts-cjk"
    "noto-fonts-emoji"
    "noto-fonts-extra"
    "ttf-jetbrains-mono-nerd"

    "rofi"
    "seatd"
    "lemurs"
    "alacritty"
    "rofimoji"
    "plymouth"
    "matugen-bin"
    "lxqt-policykit"

    "wtype"
    "clipcat"
    "wl-clipboard"

    "mpv"
    "mpc"
    "mpd-mpris"
    "mpv-mpris"
    "pavucontrol"

    "tor"
    "aria2"
    # "ngrok"
    # "yt-dlp"
    # "termshark"
    # "wireshark-cli"
    # "wikiman"
    # "udiskie"
    # "blueman"
    "network-manager-applet"

    "rsync"
    "zathura"
    # "zathura-cb"
    # "zaread-git"
    "tesseract"
    "tesseract-data-eng"
    "zathura-pdf-mupdf"

    "waybar"
    "swaync"

    "imv"
    "swww"
    "grim"
    "slurp"
    "swappy"
    "wf-recorder"

    # "qt5-wayland"
    # "qt6-wayland"

    "xdg-desktop-portal"
    "xdg-desktop-portal-gtk"
    "xdg-desktop-portal-wlr"

    # "hyprland"
    # "hyprlock"
    # "hyprshader"
    # "hyprshot"
    # "hypridle-git"
    "hyprpicker-git"
    # "xdg-desktop-portal-hyprland"
)

SANDBOX=(
    # "vhs"
    # "direnv"
    # "picard"
    "tailscale"
    "discord"
)

paru -S --noconfirm "${CORE[@]}"
paru -S --noconfirm "${BASE[@]}"
paru -S --noconfirm "${PLAY[@]}"

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
sh <(curl https://raw.githubusercontent.com/0x15BA88FF/devault/refs/heads/main/scripts/install.sh)

# curl -fsS https://dotenvx.sh | sudo sh
# curl -L https://coder.com/install.sh | sh
# sh -c "$(curl -sS https://raw.githubusercontent.com/Vendicated/VencordInstaller/main/install.sh)"
