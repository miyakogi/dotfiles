function ls
  if type -q lsd; and begin; test -n "$DISPLAY"; or test -z "$XDG_VTNR"; end
    command lsd
  else
    command ls -v --color --group-directories-first
  end
end
