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

case $XDG_CURRENT_DESKTOP in
  niri)
    dmenu_cmd=(fuzzel --dmenu)
    ;;
  Hyprland)
    dmenu_cmd=(tofi)
    ;;
  *)
    dmenu_cmd=(tofi)
    ;;
esac
    

RET=$(menu | "${dmenu_cmd[@]}" | tr -d '[:space:]')

_lock() {
  loginctl lock-session
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
  if [ "$XDG_CURRENT_DESKTOP" = Hyprland ]; then
    hyprshutdown
  else
    uwsm stop || niri msg action quit || hyprctl dispatch 'hl.dsp.exet()'
  fi
}

_reboot() {
  if [ "$XDG_CURRENT_DESKTOP" = Hyprland ]; then
    hyprshutdown --top-level 'Restarting' --post-cmd 'systemctl reboot'
  else
    systemctl reboot
  fi
}

_shutdown() {
  if [ "$XDG_CURRENT_DESKTOP" = Hyprland ]; then
    hyprshutdown --top-level 'Shutting Down' --post-cmd 'systemctl poweroff -i'
  else
    systemctl poweroff -i
  fi
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
