#!/bin/bash
# Script wrapper pour gérer les clics sur le module stopwatch
# Fichier: ~/.config/waybar/scripts/stopwatch_wrapper.sh

SCRIPT_DIR="$HOME/.config/waybar/scripts"
STOPWATCH_SCRIPT="$SCRIPT_DIR/waybar_stopwatch.py"

# Vérifier les arguments passés par Waybar
if [ "$1" = "toggle" ]; then
    # Clic gauche: start/pause
    python3 "$STOPWATCH_SCRIPT" start
elif [ "$1" = "reset" ]; then
    # Clic droit: reset
    python3 "$STOPWATCH_SCRIPT" reset
fi

# Toujours afficher le statut actuel
python3 "$STOPWATCH_SCRIPT" status
