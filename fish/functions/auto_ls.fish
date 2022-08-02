function auto_ls
  if type -q lsd; and test -n "$DISPLAY"
    lsd
  else
    ls -v --color --group-directories-first
  end
end
