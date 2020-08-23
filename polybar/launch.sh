#!/bin/bash

# Terminate already running bar instancees
killall -q polybar
killall -q picom

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 0.1; done
while pgrep -u $UID -x picom >/dev/null; do sleep 0.1; done

# Launch Polybar
if wmctrl -m | grep "bspwm" >/dev/null; then wm="bspwm"; else wm="i3"; fi
if grep "gaps" ~/.config/i3/config >/dev/null; then
  polybar "left-$wm" &
  polybar "center-$wm" &
  polybar "right-$wm" &
  picom -cb &
else
  polybar "top-$wm" &
  picom -b &
fi
