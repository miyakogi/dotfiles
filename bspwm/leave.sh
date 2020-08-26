#!/bin/sh

RET=$(echo -e "Lock\nExit\nRestart\nShutdown" | dmenu -i -fn "Fira Code-26")
case $RET in
  Lock)
    ~/.config/i3/lock.sh;;
  Exit)
    bspc quit;;
  Restart)
    systemctl reboot;;
  Shutdown)
    systemctl poweroff -i;;
  *)
    ;;
esac
