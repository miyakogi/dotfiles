#!/usr/bin/env bash

case "$XDG_SESSION_DESKTOP" in
  sway)
    class="state";;
  [Hh]yprland)
    class="class";;
  *)
    class="class";;
esac

if pulsemixer --list-sources | grep 'Name: USB PnP Audio Device Mono' | grep 'Mute: 0' &>/dev/null; then
  echo -n -e "{\"$class\": \"Info\", \"text\": \"\u2005\"}"
else
  echo -n -e "{\"$class\": \"Idle\", \"text\": \"\u2005\"}"
fi
