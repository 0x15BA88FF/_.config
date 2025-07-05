#!/usr/bin/env zsh

[[ $- != *i* ]] && return
[[ -z "$PROFILED" && -f ~/.profile ]] && source ~/.profile
[ -z "$TMUX"  ] && { tmux attach || exec tmux new-session && exit; }

_exists() { command -v "$1" &>/dev/null; }
_source() { [[ -f "$1" ]] && source "$1"; }

_source "$XDG_CONFIG_HOME/zsh/input.zsh"
_source "$XDG_CONFIG_HOME/zsh/options.zsh"
_source "$XDG_CONFIG_HOME/shell/aliasrc"
_source "$XDG_CONFIG_HOME/shell/functions"
_source "$XDG_DATA_HOME/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" ||
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "$XDG_DATA_HOME/zsh/zsh-autosuggestions/"
_source "$XDG_DATA_HOME/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ||
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$XDG_DATA_HOME/zsh/zsh-syntax-highlighting/"

_exists fzf && eval "$(fzf --zsh)"
_exists atuin && eval "$(atuin init zsh)"
_exists zoxide && eval "$(zoxide init zsh)"
_exists direnv && eval "$(direnv hook zsh)"
_exists thefuck && eval "$(thefuck --alias)"
_exists starship && eval "$(starship init zsh)"

preexec() { echo ""; }

. "$HOME/.atuin/bin/env"
