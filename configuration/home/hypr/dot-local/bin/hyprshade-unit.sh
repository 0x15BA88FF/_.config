#!/usr/bin/env bash

install() {
    hyprshade install
    systemctl --user enable --now hyprshade.timer
}

uninstall() {
    systemctl --user disable hyprshade.timer
}

case "$1" in
    install)    install ;;
    uninstall)  uninstall ;;
    *) echo "hyprshade-unit [install | uninstall]" ;;
esac
