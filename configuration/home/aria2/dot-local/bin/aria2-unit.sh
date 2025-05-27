install() {
    systemctl --user daemon-reload
    systemctl --user enable --now aria2cd.service
}

uninstall() {
    systemctl --user disable --now aria2cd.service
}

case "$1" in
    install)    install ;;
    uninstall)  uninstall ;;
    *) echo "aria2-unit [install | uninstall]" ;;
esac
