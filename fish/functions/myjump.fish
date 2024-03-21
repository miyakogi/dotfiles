function myjump
  if type -q __zoxide_zi
    __zoxide_zi ""
    commandline -f repaint
  end
end
