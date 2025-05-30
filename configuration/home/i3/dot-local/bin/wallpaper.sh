#!/bin/bash

INTERVAL=300
SHUFFLE=true
WALLHISTSIZE="${WALLHISTSIZE:-100}"
SHADERS_PATH="${SCREEN_SHADER_PATH:-HOME/.config/hypr/shaders}"
WALLPAPERS_PATH="${WALLPAPER_DIR:-$HOME/.local/share/wallpapers}"
WALLPAPER_STATE_DIR="${WALLPAPER_STATE:-$HOME/.local/state/wallpaper}"

make_state() {
    [ ! -d "$WALLPAPER_STATE_DIR" ] && mkdir -p "$WALLPAPER_STATE_DIR"
    [ ! -d "$WALLPAPERS_PATH" ] && echo "[ ERROR ] $WALLPAPERS_PATH does not exist" && exit 1
    [ ! -f "$WALLPAPER_STATE_DIR/cache_index" ] && echo "1" > "$WALLPAPER_STATE_DIR/cache_index"
    [ ! -f "$WALLPAPER_STATE_DIR/cache" ] && touch "$WALLPAPER_STATE_DIR/cache" && cache_wallpapers
    [ ! -f "$WALLPAPER_STATE_DIR/index" ] && echo "1" > "$WALLPAPER_STATE_DIR/index"
    [ ! -f "$WALLPAPER_STATE_DIR/state" ] && touch "$WALLPAPER_STATE_DIR/state" && load_wallpaper
    [ ! -f "$WALLPAPER_STATE_DIR/theme" ] && echo "dark" > "$WALLPAPER_STATE_DIR/theme"
}

cache_wallpapers() {
    make_state
    wallpapers=$(find -L "$WALLPAPERS_PATH/" -type f -iregex '.*\.\(jpg\|jpeg\|png\|gif\)$')
    if [[ SHUFFLE ]]; then
        echo "$wallpapers" | shuf >"$WALLPAPER_STATE_DIR/cache"
    else
        echo "$wallpapers" >"$WALLPAPER_STATE_DIR/cache"
    fi
    echo "[ INFO ] Cached $(wc -l <"$WALLPAPER_STATE_DIR/cache") wallpapers"
}

load_wallpaper() {
    make_state
    state_size=$(wc -l <"$WALLPAPER_STATE_DIR/state")
    cache_size=$(wc -l <"$WALLPAPER_STATE_DIR/cache")
    cache_index=$(cat "$WALLPAPER_STATE_DIR/cache_index")

    if [ "$cache_index" -ge "$cache_size" ]; then
        cache_wallpapers
        cache_index=0
    fi

    wallpaper=$(sed -n "$((cache_index + 1))p" "$WALLPAPER_STATE_DIR/cache")
    echo "$wallpaper" >>"$WALLPAPER_STATE_DIR/state"

    if [ "$state_size" -gt "$WALLHISTSIZE" ]; then
        sed -i "1,$((state_size - WALLHISTSIZE))d" "$WALLPAPER_STATE_DIR/state"
    fi

    cache_index=$((cache_index + 1))
    echo "$cache_index" >"$WALLPAPER_STATE_DIR/cache_index"
}

set_theme() {
    make_state
    echo "[ INFO ] Switched to $1 theme"
    echo "$1" >"$WALLPAPER_STATE_DIR/theme"
    reload_wallpaper
}

toggle_theme() {
    current_theme=$(cat "$WALLPAPER_STATE_DIR/theme")
    [[ "$current_theme" = "dark" ]] && set_theme "light" || set_theme "dark"
}

reload_wallpaper() {
    make_state
    index=$(cat "$WALLPAPER_STATE_DIR/index")
    echo "[ INFO ] Reloading walpaper"
    set_wallpaper_by_index "$index"
}

set_wallpaper() {
    make_state
    WALLPAPER="$1"

    echo "[ INFO ] Creating wallpaper link"
    echo "$WALLPAPERS_PATH/background --> $WALLPAPER"
    ln -f "$WALLPAPER" "$WALLPAPERS_PATH/background"

    echo "[ INFO ] Applying wallpaper"
    current_theme=$(cat "$WALLPAPER_STATE_DIR/theme")

    feh --no-fehbg --bg-fill "$WALLPAPER"
    matugen --quiet --mode $current_theme image "$WALLPAPER"
}

set_wallpaper_by_index() {
    make_state
    WALLPAPER=$(sed -n "$1p" "$WALLPAPER_STATE_DIR/state")
    set_wallpaper "$WALLPAPER"
}

next_wallpaper() {
    make_state
    index=$(cat "$WALLPAPER_STATE_DIR/index")
    index=$((index + 1))

    if [ "$index" -ge "$(wc -l <"$WALLPAPER_STATE_DIR/state")" ]; then
        load_wallpaper
    fi

    echo "$index" >"$WALLPAPER_STATE_DIR/index"
    set_wallpaper_by_index "$index"
}

previous_wallpaper() {
    make_state
    index=$(cat "$WALLPAPER_STATE_DIR/index")
    index=$((index - 1))

    if [ "$index" -lt 0 ]; then
        index=$(($(wc -l <"$WALLPAPER_STATE_DIR/state") - 1))
    fi

    echo "$index" >"$WALLPAPER_STATE_DIR/index"
    set_wallpaper_by_index "$index"
}

play_slideshow() {
    make_state
    echo "[ INFO ] Playing Slideshow"
    while true; do
        next_wallpaper
        sleep $INTERVAL
    done
}

pause_slideshow() {
    make_state
    echo "[ INFO ] Slideshow paused"
    killall wallpaper 2>/dev/null
}

toggle_slideshow() {
    if pgrep -f "bash.*wallpaper" >/dev/null; then
        pause_slideshow
    else
        play_slideshow &
    fi
}

reset() {
    rm -rf "$WALLPAPER_STATE_DIR"
}

fzf_image_menu() {
    local preview_cmd="filepath={}; convert $WALLPAPERS_PATH/$filepath -resize 800x600 sixel:-"
    local wallpaper=$(
        find -L "$WALLPAPERS_PATH/" -type f -iregex '.*\.\(jpg\|jpeg\|png\|gif\)$' -printf '%P\n' |
        fzf --height 80% \
            --preview-window=right:50%:wrap \
            --preview "$preview_cmd"
    )

    [ -z "$wallpaper" ] && exit 1
    set_wallpaper "$WALLPAPERS_PATH/$wallpaper"
}

rofi_image_menu() {
    local DMENU_CONFIG="$HOME/.config/rofi/wallpapers.rasi"

    wallpapers=$(find -L "$WALLPAPERS_PATH/" -type f -iregex '.*\.\(jpg\|jpeg\|png\|gif\)$')
    SELECTED_WALLPAPER=$(echo "$wallpapers" | rofi -dmenu -config "$DMENU_CONFIG" -p "Select a wallpaper:")
    [[ -z "$SELECTED_WALLPAPER" ]] && exit 1

    set_wallpaper "$SELECTED_WALLPAPER"
}

rofi_menu() {
    local DMENU_CONFIG="$HOME/.config/rofi/controls.rasi"

    local options=(
        "Next Wallpaper                 :next_wallpaper"
        "Prev Wallpaper                 :previous_wallpaper"
        "Select Wallpaper               :rofi_image_menu"
        "Play Slideshow                 :play_slideshow"
        "Pause Slideshow                :pause_slideshow"
        "Toggle Theme                   :toggle_theme"
        "Reset                          :reset"
    )

    local formatted_options=""
    for option in "${options[@]}"; do
        IFS=':' read -r label command <<<"$option"
        formatted_options+="$label\n"
    done

    local selected=$(echo -e "${formatted_options%\\n}" | rofi -config "$DMENU_CONFIG" -dmenu -p "Select an option:")

    if [ -n "$selected" ]; then
        for option in "${options[@]}"; do
            IFS=':' read -r label command <<<"$option"
            [[ "$selected" == "$label" ]] && {
                sleep 0.3
                eval "$command" &
                exit 0
            }
        done
    fi
}

case "$1" in
"image") set_wallpaper "$2" ;;

"play") play_slideshow ;;
"pause") pause_slideshow ;;
"toggle") toggle_slideshow ;;

"next") next_wallpaper ;;
"prev") previous_wallpaper ;;

"reset") reset ;;
"theme") set_theme $2;;
"toggle_theme") toggle_theme ;;

"fzf") fzf_image_menu ;;
"menu") rofi_menu ;;
"image-menu") rofi_image_menu ;;
*)
    echo "Usage: $0 [command]"
    echo "Commands:"
    echo "    image [path]    Set specific wallpaper"
    echo "    play            Start slideshow"
    echo "    pause           Pause slideshow"
    echo "    toggle          Toggle slideshow"
    echo "    next            Next wallpaper"
    echo "    prev            Previous wallpaper"
    echo "    reset           Reset wallpaper state"
    echo "    theme           Set theme (light/dark)"
    echo "    toggle_theme    Toggle theme (light/dark)"
    echo "    fzf             Open fzf image selection menu"
    echo "    menu            Open rofi selection menu"
    echo "    image-menu      Open rofi image selection menu"
    exit 1
;;
esac
