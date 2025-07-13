#!/usr/bin/env bash
#
# chrono.sh — stopwatch / chronometer helper for Waybar
#
# Bindings you’ll want in your Waybar config:
#
#   "custom/chrono": {
#       "exec": "$HOME/.config/waybar/scripts/chrono.sh",
#       "on-click": "$HOME/.config/waybar/scripts/chrono.sh toggle",        // L-click
#       "on-click-right": "$HOME/.config/waybar/scripts/chrono.sh reset",   // R-click
#       "interval": 1,
#       "return-type": "json",
#       "tooltip": false
#   }
#
# CSS classes emitted: running | paused | stopped
# Example CSS:
#   #custom-chrono.running { color: #27ae60; }
#   #custom-chrono.paused  { color: #e67e22; }
#   #custom-chrono.stopped { color: #555;    }
#

set -euo pipefail

STATE_FILE="${XDG_RUNTIME_DIR:-/tmp}/waybar-chrono.state"
now=$(date +%s)

#######################################
# helper: write current status
#######################################
write_state() {
    printf '%s' "$1" >"$STATE_FILE"
}

#######################################
# branch 1 – handle clicks
#######################################
case "${1:-}" in
    toggle)
        if [[ -f $STATE_FILE ]]; then
            read -r val < "$STATE_FILE"
            if (( val >= 0 )); then               # running → pause
                write_state $(( -(now - val) ))   # store elapsed as negative
            else                                  # paused  → resume
                write_state $((  now + val  ))    # val negative ⇒ -val = elapsed
            fi
        else                                      # never started → start
            write_state "$now"
        fi
        exit 0
        ;;
    reset)
        rm -f "$STATE_FILE" 2>/dev/null || true
        exit 0
        ;;
esac

#######################################
# branch 2 – display (called every second)
#######################################
elapsed=0
class="stopped"

if [[ -f $STATE_FILE ]]; then
    read -r val < "$STATE_FILE"
    if (( val >= 0 )); then
        elapsed=$(( now - val ))
        class="running"
    else
        elapsed=$(( -val ))
        class="paused"
    fi
fi

# hh:mm:ss formatting
printf -v hh '%02d' $(( elapsed / 3600 ))
printf -v mm '%02d' $(( (elapsed / 60) % 60 ))
printf -v ss '%02d' $(( elapsed % 60 ))

# JSON for Waybar
printf '{"text":"⏱ %s:%s:%s","class":"%s"}\n' "$hh" "$mm" "$ss" "$class"
