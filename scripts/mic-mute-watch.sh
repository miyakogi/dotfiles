#!/usr/bin/env bash

if pulsemixer --list-sources | grep 'Name: USB PnP Audio Device Mono' | grep 'Mute: 0' &>/dev/null; then
  echo -n -e "{\"class\": \"Info\", \"text\": \"\u2005\"}"
else
  echo -n -e "{\"class\": \"Idle\", \"text\": \"\u2005\"}"
fi
