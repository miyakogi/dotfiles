#!/usr/bin/env bash

if type logseq &>/dev/null; then
  cmd=logseq
elif type logseq-desktop-electron &>/dev/null; then
  cmd=logseq-desktop-electron
else
  echo "Logseq Not Found"
  notify-send -u critical "Command Not Found Error" "Logseq Not Found"
  exit 1
fi

exec app2unit -- "$cmd" "$(chromium-options wayland)"
