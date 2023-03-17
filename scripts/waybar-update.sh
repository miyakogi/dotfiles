#!/usr/bin/bash

# Pacman DB path
dbpath="/tmp/checkup-db-waybar"
local_dbpath="$dbpath/local"

# Create DB link if not exist
if [ ! -e "$local_dbpath" ]; then
  ln -s /var/lib/pacman "$local_dbpath" &>/dev/null
fi

# Update database
fakeroot -- pacman -Sy --dbpath /tmp/checkup-db-waybar --logfile /dev/null &>/dev/null

# Count updates
# pacman
num_pacman=$(fakeroot -- pacman -Qu --dbpath /tmp/checkup-db-waybar | wc -l)
# AUR
num_aur=$(paru -Qua | grep -c -v '\[ignored\]')
# Both
num=$(("$num_pacman"+"$num_aur"))

if [ "$num" -gt 0 ]; then
  echo "{\"text\": \" $num\", \"class\": \"info\"}"
else
  echo '{"text": "", "class": "idle"}'
fi
