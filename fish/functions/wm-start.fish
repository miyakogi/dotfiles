#!/usr/bin/env fish

function wm-start
  if command -q uwsm
    exec uwsm start (string lower $argv[1]).desktop
  else
    exec "$argv[1]"
  end
end
