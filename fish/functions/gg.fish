#!/usr/bin/env fish

function gg
  if git rev-parse --is-inside-work-tree &>/dev/null
    cd (pwd)/(git rev-parse --show-cdup)
  else
    cd ~
  end
end
