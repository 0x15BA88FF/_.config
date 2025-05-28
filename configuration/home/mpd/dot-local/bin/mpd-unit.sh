install() {
    systemctl --user enable mpd.service
    systemctl --user start mpd.service

    systemctl --user enable mpDris2.service
    systemctl --user start mpDris2.service

    systemctl --user status mpd.service
    systemctl --user status mpd.service
}

uninstall() {
    systemctl --user stop mpd.service
    systemctl --user disable mpd.service

    systemctl --user stop mpDris2.service
    systemctl --user disable mpDris2.service
}

case "$1" in
    install)    install ;;
    uninstall)  uninstall ;;
    *) echo "mpd-unit [install | uninstall]" ;;
esac
