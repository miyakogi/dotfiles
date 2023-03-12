#!/usr/bin/bash

num=$(($(pacman -Qu | wc -l)+$(paru -Qua | grep -c -v '\[ignored\]')))

if [ "$num" -gt 0 ]; then
  echo "{\"text\": \" $num\", \"class\": \"info\"}"
else
  echo '{"text": "", "class": "idle"}'
fi
