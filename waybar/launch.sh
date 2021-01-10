#!/usr/bin/env zsh

# Terminate current running waybar instances
killall waybar

# Wait until the processes to be shut down
while pgrep -x waybar >/dev/null; do sleep 0.1; done

# Launch waybar
waybar &
