#!/bin/bash

CLOCK_CONFIG_DIR="$HOME/.config/clock"
ALARMS_FILE="$CLOCK_CONFIG_DIR/alarms.conf"
TIMEZONES_CONFIG="$CLOCK_CONFIG_DIR/timezones.conf"


get_current_timezone() {
    timedatectl show --property=Timezone --value 2>/dev/null || date +%Z
}

validate_timezone() {
    local tz="$1"

    if timedatectl list-timezones | grep -q "^$tz$"; then
        return 0
    else
        return 1
    fi
}

format_time() {
    local label="$1"
    local timezone="$2"
    local time=$(TZ="$timezone" date "+%H:%M:%S")

    printf "%-20s %s\n" "$label:" "$time"
}

show_world_clock() {
    local current_tz=$(get_current_timezone)

    echo "World Clock"
    echo "==========="

    format_time "Current" "$current_tz"

    if [[ -f "$TIMEZONES_CONFIG" ]]; then
        while IFS=':' read -r label timezone; do
            [[ -z "$label" || -z "$timezone" ]] && continue
            [[ "$label" =~ ^[[:space:]]*# ]] && continue  # Skip comments
            if validate_timezone "$timezone"; then
                format_time "$label" "$timezone"
            else
                echo "Invalid timezone: $timezone" >&2
            fi
        done < "$TIMEZONES_CONFIG"
    fi
}

show_world_clock_fzf() {
    local selected_tz=$(timedatectl list-timezones | fzf --prompt="Select timezone: ")

    if [[ -n "$selected_tz" ]]; then
        echo "Selected Timezone"
        echo "================"
        format_time "Selected" "$selected_tz"
    fi
}

run_stopwatch() {
    local start_time=$(date +%s%6N)
    local elapsed=0
    local paused=false
    local pause_duration=0
    local pause_start=0
    local lap_count=0
    local laps=()

    stty -echo -icanon time 0 min 0

    while true; do
        clear
        echo "Stopwatch"
        echo "========="
        echo

        if [[ "$paused" == "true" ]]; then
            echo "Status: PAUSED"
        else
            echo "Status: RUNNING"
        fi
        echo

        if [[ "$paused" == "true" ]]; then
            elapsed=$(($(date +%s%6N) - start_time - pause_duration))
        else
            elapsed=$(($(date +%s%6N) - start_time - pause_duration))
        fi

        local current_time=$(date +%s%6N)
        local precise_elapsed=$((current_time - start_time - pause_duration))
        local hours=$((precise_elapsed / 3600000000))
        local minutes=$(((precise_elapsed % 3600000000) / 60000000))
        local seconds=$(((precise_elapsed % 60000000)))
        local sec_part=$((seconds / 1000000))
        local microsec_part=$((seconds % 1000000))

        printf "%02d:%02d:%02d.%06d\n\n" "$hours" "$minutes" "$sec_part" "$microsec_part"

        if [[ ${#laps[@]} -gt 0 ]]; then
            echo "Laps:"
            echo "-----"
            printf "%-5s %-15s %s\n" "Lap" "Lap Time" "Total Time"

            for lap in "${laps[@]}"; do
                echo "$lap"
            done

            echo
        fi

        echo "[p] pause/resume [l] lap [r] reset [q] quit"
        read -t 1 -n 1 key

        case "$key" in
            p|P)
                if [[ "$paused" == "true" ]]; then
                    pause_duration=$((pause_duration + $(date +%s%6N) - pause_start))
                    paused=false
                else
                    pause_start=$(date +%s%6N)
                    paused=true
                fi
                ;;
            l|L)
                if [[ "$paused" == "false" ]]; then
                    lap_count=$((lap_count + 1))
                    local lap_time_formatted=$(printf "%02d:%02d:%02d.%06d" "$hours" "$minutes" "$sec_part" "$microsec_part")
                    local total_time_formatted=$(printf "%02d:%02d:%02d.%06d" "$hours" "$minutes" "$sec_part" "$microsec_part")
                    laps+=("$(printf "%-5d %-15s %s" "$lap_count" "$lap_time_formatted" "$total_time_formatted")")
                fi
                ;;
            r|R)
                start_time=$(date +%s%6N)
                pause_duration=0
                paused=false
                lap_count=0
                laps=()
                ;;
            q|Q)
                break
                ;;
        esac
    done

    stty echo icanon
    clear
}

parse_duration() {
    local duration="$1"
    local total_seconds=0

    if [[ "$duration" =~ ([0-9]+)h ]]; then
        total_seconds=$((total_seconds + ${BASH_REMATCH[1]} * 3600))
    fi
    if [[ "$duration" =~ ([0-9]+)m ]]; then
        total_seconds=$((total_seconds + ${BASH_REMATCH[1]} * 60))
    fi
    if [[ "$duration" =~ ([0-9]+)s ]]; then
        total_seconds=$((total_seconds + ${BASH_REMATCH[1]}))
    fi

    echo "$total_seconds"
}

timer_notification() {
    local title="$1"
    local message="Timer finished"
    [[ -n "$title" ]] && message="$title - Timer finished"

    if command -v notify-send &> /dev/null; then
        notify-send "Clock Timer" "$message"
    fi

    if command -v paplay &> /dev/null; then
        paplay /usr/share/sounds/alsa/Front_Left.wav 2>/dev/null || true
    elif command -v aplay &> /dev/null; then
        aplay /usr/share/sounds/alsa/Front_Left.wav 2>/dev/null || true
    fi
}

run_timer() {
    local duration="$1"
    local title="$2"

    local total_seconds=$(parse_duration "$duration")
    if [[ "$total_seconds" -le 0 ]]; then
        echo "Invalid duration format. Use formats like: 5m, 1h30m, 90s, 1h30m45s"
        return 1
    fi

    local start_time=$(date +%s)
    local paused=false
    local pause_duration=0
    local pause_start=0

    stty -echo -icanon time 0 min 0

    while true; do
        clear
        echo "Timer"
        echo "====="
        echo

        [[ -n "$title" ]] && echo "Title: $title" && echo

        if [[ "$paused" == "true" ]]; then
            echo "Status: PAUSED"
        else
            echo "Status: RUNNING"
        fi
        echo

        local elapsed=$(($(date +%s) - start_time - pause_duration))
        local remaining=$((total_seconds - elapsed))

        if [[ "$remaining" -le 0 ]]; then
            echo "TIME'S UP!"
            echo
            echo "Press any key to exit..."
            timer_notification "$title"
            read -n 1
            break
        fi

        local hours=$((remaining / 3600))
        local minutes=$(((remaining % 3600) / 60))
        local seconds=$((remaining % 60))

        printf "%02d:%02d:%02d\n\n" "$hours" "$minutes" "$seconds"
        echo "[p] pause/resume [q] quit"
        read -t 1 -n 1 key

        case "$key" in
            p|P)
                if [[ "$paused" == "true" ]]; then
                    pause_duration=$((pause_duration + $(date +%s) - pause_start))
                    paused=false
                else
                    pause_start=$(date +%s)
                    paused=true
                fi
                ;;
            q|Q)
                break
                ;;
        esac
    done

    stty echo icanon
    clear
}

list_alarms() {
    echo "Scheduled Alarms"
    echo "================"

    if [[ -f "$ALARMS_FILE" ]]; then
        if [[ -s "$ALARMS_FILE" ]]; then
            printf "%-8s %-20s %s\n" "Time" "Label" "Frequency"
            echo "----------------------------------------"

            while IFS='|' read -r time label frequency; do
                [[ -z "$time" ]] && continue
                [[ "$time" =~ ^[[:space:]]*# ]] && continue
                printf "%-8s %-20s %s\n" "$time" "$label" "$frequency"
            done < "$ALARMS_FILE"
        else
            echo "No alarms configured."
        fi
    else
        echo "No alarms configured."
    fi
}

edit_alarms() {
    local editor="${EDITOR:-nano}"

    if [[ ! -f "$ALARMS_FILE" ]]; then
        mkdir -p "$CLOCK_CONFIG_DIR"
        touch "$ALARMS_FILE"

        echo "# Alarm configuration file" > "$ALARMS_FILE"
        echo "# Format: HH:MM|Label|Frequency" >> "$ALARMS_FILE"
        echo "# Frequency format: su,m,t,w,th,f,s (optional)" >> "$ALARMS_FILE"
        echo "# Example: 07:30|Morning alarm|m,t,w,th,f" >> "$ALARMS_FILE"
    fi

    "$editor" "$ALARMS_FILE"
}

main() {
    case "$1" in
        world)
            case "$2" in
                --fzf)
                    show_world_clock_fzf
                    ;;
                *)
                    show_world_clock
                    ;;
            esac
            ;;
        stopwatch)
            run_stopwatch
            ;;
        timer)
            if [[ -z "$2" ]]; then
                echo "Usage: clock timer <duration> [title]"
                echo "Duration format: 5m, 1h30m, 90s, 1h30m45s"
                return 1
            fi
            run_timer "$2" "$3"
            ;;
        alarm)
            case "$2" in
                list)
                    list_alarms
                    ;;
                edit)
                    edit_alarms
                    ;;
                *)
                    echo "Usage: clock alarm [list|edit]"
                    echo "  list - List all alarms"
                    echo "  edit - Edit alarm file"
                    return 1
                    ;;
            esac
            ;;
        *)
            echo "Simple Clock Shell Program"
            echo "Usage: clock [world|stopwatch|timer|alarm] [options]"
            echo
            echo "Commands:"
            echo "  world [--fzf]                  - Show world clock"
            echo "  stopwatch                      - Run stopwatch"
            echo "  timer <duration> [title]       - Run timer"
            echo "  alarm [list|edit]              - Manage alarms"
            echo
            echo "Examples:"
            echo "  clock world"
            echo "  clock world --fzf"
            echo "  clock stopwatch"
            echo "  clock timer 5m \"Break time\""
            echo "  clock alarm list"
            echo "  clock alarm edit"
            return 1
            ;;
    esac
}

main "$@"
