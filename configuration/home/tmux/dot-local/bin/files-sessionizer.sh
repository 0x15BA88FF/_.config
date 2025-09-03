#!/usr/bin/env bash

SESSION="yazi"
STATE_FILE="${XDG_STATE_HOME:-$HOME/.local/state}/tmux-file-manager"

mkdir -p "$(dirname "$STATE_FILE")"

if tmux has-session -t "$SESSION" 2>/dev/null; then
    [ -n "$TMUX" ] && tmux switch-client -t "$SESSION" || tmux attach -t "$SESSION"
    exit 0
fi

LAST_DIR=$([[ -f "$STATE_FILE" && -d "$(cat "$STATE_FILE")" ]] && cat "$STATE_FILE" || echo "$HOME")

tmux new-session -d -s "$SESSION" -c "$LAST_DIR" "$SESSION; echo \$PWD > '$STATE_FILE'"

[ -n "$TMUX" ] && tmux switch-client -t "$SESSION" || tmux attach -t "$SESSION"
