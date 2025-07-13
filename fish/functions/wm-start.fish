#!/usr/bin/env fish

function wm-start
  if command -q uwsm
    exec uwsm start "$argv[1]"
  else
    exec "$argv[1]"
  end
end
