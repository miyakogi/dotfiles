#!/bin/sh
# from https://qiita.com/matoruru/items/ab491eac6b2b74e3ce3b

if ! updates_pacman=$(checkupdates 2>/dev/null | wc -l); then
  updates_pacman=0
fi

if ! updates_yay=$(yay -Qum 2>/dev/null | wc -l); then
  updates_yay=0
fi

updates=$(("$updates_pacman" + "$updates_yay"))

if [ "$updates" -gt 0 ]; then
  echo " $updates"
else
  echo ""
fi
