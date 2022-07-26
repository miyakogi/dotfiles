#!/usr/bin/env bash

# get WM name
WM=$(wmctrl -m | grep "Name" | sed 's/^Name: \(.\+\)$/\1/' | tr '[:upper:]' '[:lower:]')

# show menu by rofi (first space is trimmed by sh/bash, so use ASCII code (0x20))
menu="\x20Lock\0icon\x1fsystem-lock-screen\n Suspend\0icon\x1fsystem-lock-screen\n Exit\0icon\x1fsystem-log-out\n Restart\0icon\x1fsystem-reboot\n Shutdown\0icon\x1fsystem-shutdown"
RET=$(echo -en $menu | rofi -dmenu -i -p "Select" -theme leave-theme | tr -d '[:space:]')

_lock() {
  lock-screen
}

_suspend() {
  lock-screen
  sleep 3
  systemctl suspend
}

_exit() {
  killall redshift
  case $WM in
    bspwm)
      bspc quit;;
    i3)
      i3-msg exit;;
    wlroots*)  # sway
      swaymsg exit;;
    *)
      ;;
  esac
}

_reboot() {
  systemctl reboot
}

_shutdown() {
  systemctl poweroff -i
}

case $RET in
  Lock)
    _lock;;
  Suspend)
    _suspend;;
  Exit)
    _exit;;
  Restart)
    _reboot;;
  Shutdown)
    _shutdown;;
  *)
    ;;
esac
