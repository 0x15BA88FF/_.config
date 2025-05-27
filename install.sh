#!/usr/bin/env bash
set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_CONFIG="$REPO_DIR/configuration/home"
ROOT_CONFIG="$REPO_DIR/configuration/root"

echo "Installing home dotfiles..."
cd "$HOME_CONFIG"
stow --dotfiles --target="$HOME" */

if [ "$EUID" -ne 0 ]; then
    echo "Skipping root dotfiles (run as root to install)..."
else
    echo "Installing root dotfiles..."
    cd "$ROOT_CONFIG"
    stow --dotfiles --target="/root" */
fi
