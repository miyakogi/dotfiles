#!/usr/bin/env bash

TERM_CLASS=scratchterm

if is-4k; then
  CLASS="$TERM_CLASS"-dp1
  SIZE="2800 1600"
else
  CLASS="$TERM_CLASS"-dp2
  SIZE="1820 1280"
fi

cmd=(
  setsid
  app2unit
  terminal
  --class "$CLASS"
)

if which zellij &>/dev/null; then
  cmd+=(-e zellij)
  if zellij ls | rg "$CLASS" &>/dev/null; then
    cmd+=(a)
  else
    cmd+=(-s)
  fi
  cmd+=("$CLASS")
fi

# check if window exists
if ! swaymsg -t get_tree | jq -e ".. | objects | select(.app_id? == \"$CLASS\")" &>/dev/null; then
  # not exist -> open new window
  notify-send -t 500 'Sway' 'Spawning new scratchpad terminal'
  "${cmd[@]}" & disown
  sleep 0.2
  swaymsg "[app_id=\"$CLASS\"] scratchpad show, resize set $SIZE, move position center"
else
  swaymsg "[app_id=\"$CLASS\"] scratchpad show"
fi

