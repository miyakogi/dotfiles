#!/usr/bin/bash

num=$( paru -Qu | grep -c -v '\[ignored\]' )

if [ "$num" -gt 0 ]; then
  echo "{\"text\": \" $num\", \"class\": \"info\"}"
else
  echo '{"text": "", "class": "idle"}'
fi
