#!/usr/bin/env zsh

# Terminate already running bar instancees
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 0.1; done

# get window manager name
wm=$(wmctrl -m | grep "Name:" | sed 's/^Name: \(.\+\)$/\1/' | tr '[:upper:]' '[:lower:]')

if grep -q "gaps" ${XDG_CONFIG_HOME:-$HOME/.config}/i3/config; then
  polybar "left-$wm" &
  polybar "center-$wm" &
  polybar "right-$wm" &
else
  polybar "top-$wm" &
fi
