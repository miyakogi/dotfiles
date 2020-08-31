#!/bin/sh

# get WM name
WM=$(wmctrl -m | grep "Name" | sed -r 's/^Name: ([a-zA-Z0-9\-_]+)$/\1/')

# show menu by rofi
menu="Lock\nExit\nRestart\nShutdown"
RET=$(echo -e $menu | rofi -dmenu -i -p "Select" -theme leave-theme)

function lock() {
  ~/.config/i3/lock.sh
}

function _exit() {
  killall redshift
  case $WM in
    awesome)
      awesome-client "awesome.quit()";;
    bspwm)
      bspc quit;;
    i3)
      i3-msg exit;;
    KWin)
      lxqt-leave --logout;;
    *)
      ;;
  esac
}

function reboot() {
  if [[ $WM = "KWin" ]]; then
    lxqt-leave --reboot
  else
    systemctl reboot
  fi
}

function shutdown() {
  if [[ $WM = "KWin" ]]; then
    lxqt-leave --shutdown
  else
    systemctl poweroff -i
  fi
}

case $RET in
  Lock)
    lock;;
  Exit)
    _exit;;
  Restart)
    reboot;;
  Shutdown)
    shutdown;;
  *)
    ;;
esac
