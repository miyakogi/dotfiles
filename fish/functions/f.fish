#!/usr/bin/env fish

function f
  if ! type -q fzf
    echo "`f` command requires `fzf` command"
    return 1
  end

  set -l target (fzf -q "$argv") || return 0
  if test -f "$target"
    "$EDITOR" "$target"
  else if test -d "$target"
    cd "$target"
  end
end
