function ls
  if test -n "$DISPLAY"; or test -n "$WAYLAND_DISPLAY"; or test -z "$XDG_VTNR"
    if type -q eza
      command eza --icons=auto --group-directories-first --sort Filename --group --time-style "+%Y-%m-%d %H:%M" $argv
    else
      command ls -v --color --group-directories-first $argv
    end
  else
    command ls $argv
  end
end
