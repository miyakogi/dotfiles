function auto_ls
  if type -q lsd; and test -n "$DISPLAY"
    lsd
  else if type -q exa; and test -n "$DISPLAY"
    exa --icons
  else
    ls -v --color --group-directories-first
  end
end
