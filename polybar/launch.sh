#!/bin/bash

# Terminate already running bar instancees
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 0.1; done

# Launch Polybar
polybar top &
