function auto_ls
  if type -q lsd
    lsd
  else if type -q exa
    exa --icons
  else
    ls
  end
end
