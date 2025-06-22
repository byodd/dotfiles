#!/usr/bin/env bash
# Toggle Waybar: si elle tourne on la tue, sinon on la (re)lance.

if pgrep -x waybar >/dev/null ; then
    pkill -x waybar            # stop
else
    # On relance dans une session détachée pour que ça ne bouche pas le shell Hyprland
    (setsid waybar >/dev/null 2>&1 &)
fi

