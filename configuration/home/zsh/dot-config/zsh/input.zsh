#!/usr/bin/env zsh

bindkey jj vi-cmd-mode

bindkey "^Z" undo
bindkey "^Y" redo

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

bindkey '^[[3~' delete-char
bindkey '^[[3;5~' kill-word

bindkey "^E" end-of-line
bindkey "^A" beginning-of-line

bindkey '^k' up-line-or-search
bindkey '^j' down-line-or-search

bindkey '^u' autosuggest-toggle
bindkey '^e' autosuggest-accept
bindkey '^r' autosuggest-execute
