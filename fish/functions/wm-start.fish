#!/usr/bin/env fish

function wm-start
  if command -q uwsm
    exec uwsm start (string lower $argv[1])-uwsm.desktop
  else
    exec "$argv[1]"
  end
end
