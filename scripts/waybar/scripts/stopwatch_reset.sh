#!/bin/bash
python3 ~/.config/waybar/scripts/waybar_stopwatch.py reset
pkill -SIGRTMIN+8 waybar
EOF
