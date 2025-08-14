#!/usr/bin/env bash

# Create DB directory if not exist
dbpath="/tmp/checkup-db-waybar"
if [ ! -e "$dbpath" ]; then
  mkdir -p "$dbpath" &>/dev/null
fi

# Create DB link if not exist
local_dbpath="$dbpath/local"
if [ ! -e "$local_dbpath" ]; then
  ln -s /var/lib/pacman/local "$local_dbpath" &>/dev/null
fi

# Update database
fakeroot -- pacman -Sy --dbpath /tmp/checkup-db-waybar --logfile /dev/null &>/dev/null

# Count updates
# pacman
num_pacman=$(fakeroot -- pacman -Qu --dbpath /tmp/checkup-db-waybar | grep -c -v '\[ignored\]')
# AUR
num_aur=$(paru -Qua | grep -c -v '\[ignored\]')
# Both
num=$(("$num_pacman"+"$num_aur"))

if [ "$num" -gt 0 ]; then
  echo "{\"text\": \" $num\", \"class\": \"info\"}"
else
  echo '{"text": "", "class": "idle"}'
fi
