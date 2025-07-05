if [ -z "${BASH_VERSION-}" ]; then
    return 1;
fi

if [[ -z "${BASH_VERSINFO-}" ]] || (( BASH_VERSINFO[0] < 3 || (BASH_VERSINFO[0] == 3 && BASH_VERSINFO[1] < 1) )); then
    return 1
fi

if [[ -n "${bash_preexec_imported:-}" || -n "${__bp_imported:-}" ]]; then
    return 0
fi
bash_preexec_imported="defined"

__bp_imported="${bash_preexec_imported}"

__bp_last_ret_value="$?"
BP_PIPESTATUS=("${PIPESTATUS[@]}")
__bp_last_argument_prev_command="$_"

__bp_inside_precmd=0
__bp_inside_preexec=0

__bp_install_string=$'__bp_trap_string="$(trap -p DEBUG)"\ntrap - DEBUG\n__bp_install'

__bp_require_not_readonly() {
  local var
  for var; do
    if ! ( unset "$var" 2> /dev/null ); then
      echo "bash-preexec requires write access to ${var}" >&2
      return 1
    fi
  done
}

__bp_adjust_histcontrol() {
    local histcontrol
    histcontrol="${HISTCONTROL:-}"
    histcontrol="${histcontrol//ignorespace}"
    if [[ "$histcontrol" == *"ignoreboth"* ]]; then
        histcontrol="ignoredups:${histcontrol//ignoreboth}"
    fi;
    export HISTCONTROL="$histcontrol"
}

__bp_preexec_interactive_mode=""

declare -a precmd_functions
declare -a preexec_functions

__bp_trim_whitespace() {
    local var=${1:?} text=${2:-}
    text="${text#"${text%%[![:space:]]*}"}"
    text="${text%"${text##*[![:space:]]}"}"
    printf -v "$var" '%s' "$text"
}


__bp_sanitize_string() {
    local var=${1:?} text=${2:-} sanitized
    __bp_trim_whitespace sanitized "$text"
    sanitized=${sanitized%;}
    sanitized=${sanitized#;}
    __bp_trim_whitespace sanitized "$sanitized"
    printf -v "$var" '%s' "$sanitized"
}

__bp_interactive_mode() {
    __bp_preexec_interactive_mode="on";
}


__bp_precmd_invoke_cmd() {
    __bp_last_ret_value="$?" BP_PIPESTATUS=("${PIPESTATUS[@]}")

    if (( __bp_inside_precmd > 0 )); then
      return
    fi
    local __bp_inside_precmd=1

    local precmd_function
    for precmd_function in "${precmd_functions[@]}"; do

        if type -t "$precmd_function" 1>/dev/null; then
            __bp_set_ret_value "$__bp_last_ret_value" "$__bp_last_argument_prev_command"
            "$precmd_function"
        fi
    done

    __bp_set_ret_value "$__bp_last_ret_value"
}

__bp_set_ret_value() {
    return ${1:+"$1"}
}

__bp_in_prompt_command() {
    local prompt_command_array IFS=$'\n;'
    read -rd '' -a prompt_command_array <<< "${PROMPT_COMMAND[*]:-}"

    local trimmed_arg
    __bp_trim_whitespace trimmed_arg "${1:-}"

    local command trimmed_command
    for command in "${prompt_command_array[@]:-}"; do
        __bp_trim_whitespace trimmed_command "$command"
        if [[ "$trimmed_command" == "$trimmed_arg" ]]; then
            return 0
        fi
    done

    return 1
}

__bp_preexec_invoke_exec() {
    __bp_last_argument_prev_command="${1:-}"
    if (( __bp_inside_preexec > 0 )); then
      return
    fi
    local __bp_inside_preexec=1

    if [[ ! -t 1 && -z "${__bp_delay_install:-}" ]]; then
        return
    fi

    if [[ -n "${COMP_POINT:-}" || -n "${READLINE_POINT:-}" ]]; then
        return
    fi
    if [[ -z "${__bp_preexec_interactive_mode:-}" ]]; then
        return
    else
        if [[ 0 -eq "${BASH_SUBSHELL:-}" ]]; then
            __bp_preexec_interactive_mode=""
        fi
    fi

    if  __bp_in_prompt_command "${BASH_COMMAND:-}"; then
        __bp_preexec_interactive_mode=""
        return
    fi

    local this_command
    this_command=$(
        export LC_ALL=C
        HISTTIMEFORMAT='' builtin history 1 | sed '1 s/^ *[0-9][0-9]*[* ] //'
    )

    if [[ -z "$this_command" ]]; then
        return
    fi

    local preexec_function
    local preexec_function_ret_value
    local preexec_ret_value=0
    for preexec_function in "${preexec_functions[@]:-}"; do
        if type -t "$preexec_function" 1>/dev/null; then
            __bp_set_ret_value "${__bp_last_ret_value:-}"
            "$preexec_function" "$this_command"
            preexec_function_ret_value="$?"
            if [[ "$preexec_function_ret_value" != 0 ]]; then
                preexec_ret_value="$preexec_function_ret_value"
            fi
        fi
    done

    __bp_set_ret_value "$preexec_ret_value" "$__bp_last_argument_prev_command"
}

__bp_install() {
    if [[ "${PROMPT_COMMAND[*]:-}" == *"__bp_precmd_invoke_cmd"* ]]; then
        return 1;
    fi

    trap '__bp_preexec_invoke_exec "$_"' DEBUG

    local prior_trap
    prior_trap=$(sed "s/[^']*'\(.*\)'[^']*/\1/" <<<"${__bp_trap_string:-}")
    unset __bp_trap_string
    if [[ -n "$prior_trap" ]]; then
        eval '__bp_original_debug_trap() {
          '"$prior_trap"'
        }'
        preexec_functions+=(__bp_original_debug_trap)
    fi

    __bp_adjust_histcontrol

    if [[ -n "${__bp_enable_subshells:-}" ]]; then

        set -o functrace > /dev/null 2>&1
        shopt -s extdebug > /dev/null 2>&1
    fi;

    local existing_prompt_command
    existing_prompt_command="${PROMPT_COMMAND:-}"
    existing_prompt_command="${existing_prompt_command//$__bp_install_string/:}"
    existing_prompt_command="${existing_prompt_command//$'\n':$'\n'/$'\n'}"
    existing_prompt_command="${existing_prompt_command//$'\n':;/$'\n'}"
    __bp_sanitize_string existing_prompt_command "$existing_prompt_command"
    if [[ "${existing_prompt_command:-:}" == ":" ]]; then
        existing_prompt_command=
    fi

    PROMPT_COMMAND='__bp_precmd_invoke_cmd'
    PROMPT_COMMAND+=${existing_prompt_command:+$'\n'$existing_prompt_command}
    if (( BASH_VERSINFO[0] > 5 || (BASH_VERSINFO[0] == 5 && BASH_VERSINFO[1] >= 1) )); then
        PROMPT_COMMAND+=('__bp_interactive_mode')
    else
        PROMPT_COMMAND+=$'\n__bp_interactive_mode'
    fi

    precmd_functions+=(precmd)
    preexec_functions+=(preexec)

    __bp_precmd_invoke_cmd
    __bp_interactive_mode
}

__bp_install_after_session_init() {
    __bp_require_not_readonly PROMPT_COMMAND HISTCONTROL HISTTIMEFORMAT || return

    local sanitized_prompt_command
    __bp_sanitize_string sanitized_prompt_command "${PROMPT_COMMAND:-}"
    if [[ -n "$sanitized_prompt_command" ]]; then
        PROMPT_COMMAND=${sanitized_prompt_command}$'\n'
    fi;
    PROMPT_COMMAND+=${__bp_install_string}
}

if [[ -z "${__bp_delay_install:-}" ]]; then
    __bp_install_after_session_init
fi;
