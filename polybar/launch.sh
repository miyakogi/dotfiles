#!/usr/bin/env zsh

# Terminate already running bar instancees
killall -q polybar
killall -q picom

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 0.1; done
while pgrep -u $UID -x picom >/dev/null; do sleep 0.1; done

# get window manager name
wm=$(wmctrl -m | grep "Name:" | sed 's/^Name: \(.\+\)$/\1/' | tr '[:upper:]' '[:lower:]')
if [[ $wm == "bspwm" ]]; then
  picom_opt="-f"
fi

if grep "gaps" ${XDG_CONFIG_HOME:-$HOME/.config}/i3/config >/dev/null; then
  polybar "left-$wm" &
  polybar "center-$wm" &
  polybar "right-$wm" &
  if [[ $wm != "kwin" ]]; then
    picom -b --corner-radius 12.0 $picom_opt --experimental-backends $QEMU_PICOM_OPTION &
  fi
else
  polybar "top-$wm" &
  if [[ $wm != "kwin" ]]; then
    picom -b $picom_opt --experimental-backends $QEMU_PICOM_OPTION &
  fi
fi
