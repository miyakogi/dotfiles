function myjump
  set -l destination (cat $HIST_DIRS_FILE | eval "$_search_cmd")
  test -z $destination; and return
  commandline -b ""
  echo ""
  commandline -f repaint
  eval "cd $destination"
  commandline -f repaint
end
