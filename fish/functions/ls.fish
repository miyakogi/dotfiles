function ls
  if type -q exa; and test -n "$DISPLAY"; or test -z "$XDG_VTNR"
    command exa --icons --group-directories-first --sort Name $argv
  else if type -q lsd; and test -n "$DISPLAY"; or test -z "$XDG_VTNR"
    command lsd
  else
    command ls -v --color --group-directories-first
  end
end
