#!/usr/bin/env bash

if [[ $(swaymsg -t get_tree | jq '.. | select(.focused?) | .name | test("youtube.*firefox$"; "ix")') == "true" ]]; then
  if [[ -n "$(pulsemixer --list-sinks | grep 'Name: Firefox' | grep -v '100%')" ]]; then
    pulsemixer --list-sinks | grep "Name: Firefox" | grep -v "100%" | while read -r line; do
      id=$(echo $line | sed -r 's/^.*ID: ([a-zA-Z0-9\-]+).*$/\1/')
      pulsemixer --id $id --set-volume 100
    done
  fi
fi

echo ""
