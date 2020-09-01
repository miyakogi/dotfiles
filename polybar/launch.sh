#!/bin/bash

# Terminate already running bar instancees
killall -q polybar
killall -q picom

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 0.1; done
while pgrep -u $UID -x picom >/dev/null; do sleep 0.1; done

# get window manager name
wm=$(wmctrl -m | grep "Name:" | sed -r 's/^Name: ([a-zA-Z0-9\-_]+)$/\1/' | tr '[:upper:]' '[:lower:]')
if [[ $wm = "bspwm" ]]; then
  picom_opt="-f"
fi

if grep "gaps" ~/.config/i3/config >/dev/null; then
  polybar "left-$wm" &
  polybar "center-$wm" &
  polybar "right-$wm" &
  if [[ $wm != "kwin" ]]; then
    picom -cb $picom_opt --experimental-backends &
  fi
else
  polybar "top-$wm" &
  if [[ $wm != "kwin" ]]; then
    picom -b $picom_opt --experimental-backends &
  fi
fi
