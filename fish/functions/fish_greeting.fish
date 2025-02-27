function fish_greeting
  if type -q fastfetch
    if test "$TERM" != "foot"
      fastfetch
    end
  end
end
