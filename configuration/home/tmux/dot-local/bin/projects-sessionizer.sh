#!/usr/bin/env bash

STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/tmux_sessionizer"
STATE_LOG="$STATE_DIR/state.log"

mkdir -p "$STATE_DIR"
touch "$STATE_LOG"

session_name_from_path() {
    basename "$1" | tr . '*' | tr -cd '[:alnum:]*-' | cut -c1-50
}

find_projects() {
    devault find . 2>/dev/null | while read -r dir; do
        dir=$(realpath "$dir" 2>/dev/null)
        [ -d "$dir" ] && echo "$dir"
    done
}

rank_projects() {
    awk -v logfile="$STATE_LOG" '
        BEGIN {
            while ((getline < logfile) > 0)
                if ($0 != "") freq[$0]++
        }
        $0 != "" {
            print freq[$0] "\t" $0
        }
    ' | sort -nr | cut -f2-
}

select_project() {
    local projects ranked selected

    projects=$(find_projects)
    [[ -z "$projects" ]] && return 1
    ranked=$(echo "$projects" | rank_projects)
    selected=$(echo "$ranked" | fzf --prompt="Select session: ")

    echo "$selected"
}

setup_session() {
    local session_name="$1"
    local path="$2"

    tmux new-session -ds "$session_name" -c "$path" -n main
}

main() {
    local selected="$1"

    if [[ -z "$selected" ]]; then
        selected=$(select_project)
        [[ -z "$selected" ]] && exit 0
    fi

    selected=$(realpath "$selected")
    echo "$selected" >> "$STATE_LOG"

    local session_name
    session_name=$(session_name_from_path "$selected")

    if tmux has-session -t="$session_name" 2>/dev/null; then
        if [[ -n "$TMUX" ]]; then
            tmux switch-client -t "$session_name"
        else
            tmux attach-session -t "$session_name"
        fi
        exit 0
    fi

    setup_session "$session_name" "$selected"

    if [[ -n "$TMUX" ]]; then
        tmux switch-client -t "$session_name"
    else
        tmux attach-session -t "$session_name"
    fi
}

main "$@"
