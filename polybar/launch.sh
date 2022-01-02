#!/usr/bin/env bash

# Terminate already running bar instancees
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar &>/dev/null; do sleep 0.1; done

# get window manager name
wm=$(wmctrl -m | grep "Name:" | sed 's/^Name: \(.\+\)$/\1/' | tr '[:upper:]' '[:lower:]')

# launch proper bar
polybar "top-$wm" &
