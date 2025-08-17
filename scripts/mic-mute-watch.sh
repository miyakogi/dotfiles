#!/usr/bin/env bash

space="\u2006"
case "$XDG_SESSION_DESKTOP" in
  sway*)
    class="state";;
  [Hh]yprland)
    class="class";;
  *)
    class="class";;
esac

if pulsemixer --list-sources | grep -e 'Name: USB PnP Audio Device Mono' -e 'Name: ArctisX PnP Microphone Mono' | grep 'Mute: 0' &>/dev/null; then
  echo -n -e "{\"$class\": \"Info\", \"text\": \"${space}\"}"
else
  echo -n -e "{\"$class\": \"Idle\", \"text\": \"${space}\"}"
fi
