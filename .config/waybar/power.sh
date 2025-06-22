#!/usr/bin/env bash
# ~/.config/waybar/power.sh

# On liste les choix
OPTIONS="Suspend\nHibernate\nReboot\nPoweroff"
CHOICE=$(echo -e $OPTIONS | wofi -dmenu -i -p "⏻ Power")

case "$CHOICE" in
  Suspend)    systemctl suspend      ;;
  Hibernate)  systemctl hibernate    ;;
  Reboot)     systemctl reboot       ;;
  Poweroff)   systemctl poweroff     ;;
esac
