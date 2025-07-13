#!/bin/bash
python3 ~/.config/waybar/scripts/waybar_stopwatch.py start
pkill -SIGRTMIN+8 waybar
