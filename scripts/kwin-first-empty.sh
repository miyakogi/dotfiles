#!/usr/bin/sh

desktops=$(qdbus org.kde.KWin /VirtualDesktopManager org.kde.KWin.VirtualDesktopManager.count)
for i in `seq $desktops`; do
  if ! xdotool search --desktop $(($i-1)) --class '.*' > /dev/null; then
    qdbus org.kde.KWin /KWin org.kde.KWin.setCurrentDesktop $i > /dev/null
    exit
  fi
done

notify-send -u critical "KWIN" "No Empty Desktop!"
