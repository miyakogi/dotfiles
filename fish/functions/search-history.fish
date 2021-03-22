function search-history
  set -l cmd (history search --reverse | eval $_search_cmd)
  test -z $cmd ; and return
  commandline -b $cmd
end

