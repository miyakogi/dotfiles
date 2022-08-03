function search-history
  if not test -z $_search_cmd
    set -l cmd (history search --reverse | eval $_search_cmd)
    test -z $cmd; and return
    commandline -b $cmd
  else
    echo -e "Install `fzf` to use search history shortcut\n\n"
    commandline -f repaint
  end
end
