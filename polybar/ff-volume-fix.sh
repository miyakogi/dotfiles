#!/bin/zsh

if ! which pulsemixer 1>/dev/null 2>&1; then
  exit 1
fi

pulsemixer --list-sinks | while read -r line; do
  if [[ "$line" == *"Name: Firefox"* ]]; then
    if [[ ! "$line" == *"Volumes: ['100%', '100%']"* ]]; then
      id=`echo $line | sed -r 's/^.*ID: ([a-zA-Z0-9\-]+).*$/\1/'`
      pulsemixer --id $id --set-volume 100
    fi
  fi
done
