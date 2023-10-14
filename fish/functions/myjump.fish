function myjump
  if type -q zi
    zi ""
    commandline -f repaint
  else
    if test -n "$_search_cmd"
      set -l destination (cat $HIST_DIRS_FILE | eval "$_search_cmd")
      test -z "$destination"; and return
      commandline -b "cd \"$destination\""
      commandline -f execute
    else
      echo -e "Install `zoxide` or `fzf` to use jump dir shortcut\n\n"
      commandline -f repaint
    end
  end
end
