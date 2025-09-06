#!/usr/bin/env bash

TERM_CLASS=scratchterm

function is_hidpi() {
  test "$(swaymsg -t get_outputs | jq '.[] | select(.focused) | .name' | tr -d '"')" = 'DP-1'
}

if is_hidpi; then
  CLASS="$TERM_CLASS"-dp1
else
  CLASS="$TERM_CLASS"-dp2
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
  "${cmd[@]}" & disown
  sleep 0.2
  swaymsg "[app_id=\"$CLASS\"] scratchpad show, resize set 2240 1480, move position center"
else
  swaymsg "[app_id=\"$CLASS\"] scratchpad show"
fi

