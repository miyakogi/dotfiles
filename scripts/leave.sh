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

RET=$(menu | tofi | tr -d '[:space:]')

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
  uwsm stop
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
