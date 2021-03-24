function chpwd
  set -l curdir (pwd | \
    string replace "$HOME" "\$HOME" | \
    string replace "$USER" "\$USER")
  begin
    grep -v -x "$curdir" "$HIST_DIRS_FILE"
    echo "$curdir"
  end | string collect | tail -n $HIST_DIRS_MAX >"$HIST_DIRS_FILE"
end
