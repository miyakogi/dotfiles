#!/usr/bin/env zsh

# get WM name
WM=$(wmctrl -m | grep "Name" | sed 's/^Name: \(.\+\)$/\1/' | tr '[:upper:]' '[:lower:]')

# show menu by rofi
menu="Lock\nExit\nRestart\nShutdown"
RET=$(echo -e $menu | rofi -dmenu -i -p "Select" -theme leave-theme)

function lock() {
  lock-screen
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
    kwin)
      lxqt-leave --logout;;
    *)
      ;;
  esac
}

function reboot() {
  if [[ $WM == "kwin" ]]; then
    lxqt-leave --reboot
  else
    systemctl reboot
  fi
}

function shutdown() {
  if [[ $WM == "kwin" ]]; then
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
