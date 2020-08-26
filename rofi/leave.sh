#!/bin/sh

# get WM name
WM=$(wmctrl -m | grep "Name" | sed -r 's/^Name: ([a-zA-Z0-9\-_]+)$/\1/')

# show menu by rofi
menu="Lock Screen\nExit\nRestart\nShutdown"
RET=$(echo -e $menu | rofi -dmenu -i -p "Select" -theme leave-theme)

case $RET in
  Lock*)
    ~/.config/i3/lock.sh;;
  Exit)
    killall redshift;
    case $WM in
      bspwm)
        bspc quit;;
      i3)
        i3-msg exit;;
      *)
        ;;
    esac ;;
  Restart)
    systemctl reboot;;
  Shutdown)
    systemctl poweroff -i;;
  *)
    ;;
esac
