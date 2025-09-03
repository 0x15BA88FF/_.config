#!/usr/bin/env bash

SESSION="notes"
NOTES_DIR=$(notes path)

if tmux has-session -t "$SESSION" 2>/dev/null; then
    [ -n "$TMUX" ] && tmux switch-client -t "$SESSION" || tmux attach -t "$SESSION"
    exit 0
fi

tmux new-session -d -s "$SESSION" -c "$NOTES_DIR"

[ -n "$TMUX" ] && tmux switch-client -t "$SESSION" || tmux attach -t "$SESSION"
