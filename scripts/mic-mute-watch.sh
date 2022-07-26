#!/usr/bin/env bash

if pulsemixer --list-sources | grep 'Name: USB PnP Audio Device Mono' | grep 'Mute: 0' &>/dev/null; then
  echo '{"state": "Info", "text": ""}'
else
  echo '{"state": "Idle", "text": ""}'
fi
