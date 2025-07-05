#!/usr/bin/env bash

language_or_tool=$(curl -s cht.sh/:list | fzf --prompt="Select language/tool: ")
[[ -z "$language_or_tool" ]] && exit 0

topics=$(curl -sf "https://cht.sh/$language_or_tool/:list")

if [[ -n "$topics" ]]; then
    topic=$(echo "$topics" | fzf --prompt="Select topic: ")
    [[ -z "$topic" ]] && exit 0
else
    read -rp "Enter query for $language_or_tool: " topic
    [[ -z "$topic" ]] && exit 0
fi

curl -s "https://cht.sh/$language_or_tool/$topic" | less -R
