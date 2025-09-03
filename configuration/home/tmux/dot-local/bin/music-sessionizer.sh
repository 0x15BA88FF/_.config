#!/usr/bin/env bash

SESSION="rmpc"

if ! tmux has-session -t "$SESSION" 2>/dev/null; then
    tmux new-session -d -s "$SESSION" "rmpc"
fi

[ -n "$TMUX" ] && tmux switch-client -t "$SESSION" || tmux attach -t "$SESSION"
