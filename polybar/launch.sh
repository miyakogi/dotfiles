#!/bin/bash

# Terminate already running bar instancees
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 0.1; done

# Launch Polybar
if grep "gaps" ~/.config/i3/config >/dev/null; then
  polybar left &
  polybar center &
  polybar right &
else
  polybar top &
fi
