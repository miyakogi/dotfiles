#!/bin/zsh

pulsemixer --list-sinks | while read -r line; do
  if [[ "$line" == *"Name: Firefox"* ]]; then
    if [[ ! "$line" == *"Volumes: ['100%', '100%']"* ]]; then
      echo ""
      exit
    fi
  fi
done

echo ""
