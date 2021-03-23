function auto_ls
  if __which lsd
    lsd
  else if __which exa
    exa --icons
  else
    ls
  end
end
