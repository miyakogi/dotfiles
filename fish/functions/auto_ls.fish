function auto_ls
  if test -z "$DISPLAY"
    ls --color --group-directories-first
  else if type -q lsd
    lsd
  else if type -q exa
    exa --icons
  else
    ls
  end
end
