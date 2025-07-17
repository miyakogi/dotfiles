#!/bin/env bash

cmd=(app2unit)

if test "$1" = "term"; then
  cmd+=(-T)
  shift
elif test "$1" = "no-term"; then
  shift
else
  notify-send -u critical "Invalid app command"
  exit 1
fi

kill "$(pidof anyrun)"

# need &>/dev/null to run discord
exec "${cmd[*]}" -- "$@" &>/dev/null
