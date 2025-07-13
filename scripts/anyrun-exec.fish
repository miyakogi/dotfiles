#!/bin/env fish

set cmd app2unit

if test $argv[1] = "term"
  set cmd[2] '-T'
  set -e argv[1]
else if test $argv[1] = "no-term"
  set -e argv[1]
else
  notify-send -u critical "Invalid app command"
  exit 1
end

kill anyrun
$cmd -- $argv &>/dev/null & disown
