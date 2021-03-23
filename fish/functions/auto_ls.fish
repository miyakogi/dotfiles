function auto_ls
  if __which exa
    exa --icons
  else if __which lsd
    lsd
  else
    ls
  end
end
