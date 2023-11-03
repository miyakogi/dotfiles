function ls
  # if type -q lsd; and begin; test -n "$DISPLAY"; or test -z "$XDG_VTNR"; end
  if test -n "$DISPLAY"; or test -z "$XDG_VTNR"
    if type -q eza
      command eza --icons --group-directories-first --sort Filename $argv
    else if type -q lsd
      command lsd $argv
    else
      command ls -v --color --group-directories-first $argv
    end
  else
    command ls $argv
  end
end
