#!/bin/bash

# Terminate already running bar instancees
killall -q polybar
killall -q picom

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 0.1; done
while pgrep -u $UID -x picom >/dev/null; do sleep 0.1; done

# Launch Polybar
if grep "gaps" ~/.config/i3/config >/dev/null; then
  polybar left &
  polybar center &
  polybar right &
  picom -cb &
else
  polybar top &
  picom -b &
fi
