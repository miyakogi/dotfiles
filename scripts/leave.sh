#!/usr/bin/env bash

# List up menu items
function menu() {
  items=(
    "Lock"
    "Suspend"
    "Hibernate"
    "Exit"
    "Reboot"
    "Shutdown"
  )
  for item in "${items[@]}"; do
    echo " $item "
  done
}

RET=$(menu | tofi --width=420 --height=420 --prompt-text="" | tr -d '[:space:]')

_lock() {
  lock-screen
}

_suspend() {
  _lock
  sleep 3
  systemctl suspend
}

_hibernate() {
  _lock
  sleep 3
  systemctl hibernate
}

_exit() {
  uwsm stop
  if [ "$XDG_CURRENT_DESKTOP" = sway ]; then
    swaymsg exit
  elif [ "$XDG_CURRENT_DESKTOP" = Hyprland ]; then
    hyprctl dispatch exit ""
  fi
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
  Hibernate)
    _hibernate;;
  Exit)
    _exit;;
  Reboot)
    _reboot;;
  Shutdown)
    _shutdown;;
  *)
    ;;
esac
