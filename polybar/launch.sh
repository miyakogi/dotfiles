#!/bin/bash

# Terminate already running bar instancees
killall -q polybar
killall -q picom

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 0.1; done
while pgrep -u $UID -x picom >/dev/null; do sleep 0.1; done

# Launch Polybar
if wmctrl -m | grep "bspwm" >/dev/null; then
  wm="bspwm"
  picom_opt="-f"
elif wmctrl -m | grep "KWin" >/dev/null; then
  wm="kwin"
else
  wm="i3"
  picom_opt=""
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
