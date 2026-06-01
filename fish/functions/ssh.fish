function ssh --wraps=ssh
  # change bg color (dark red)
  printf '\033]11;#140000\a'

  # execute SSH
  command ssh $argv

  # reset to original bg
  printf '\033]111\a'
end

