function chpwd
  set -l curdir (echo "$PWD" | \
    string replace "$HOME" "\$HOME" | \
    string replace "$USER" "\$USER")
  begin
    cat "$HIST_DIRS_FILE" | grep -v -x "$curdir"
    echo "$curdir"
  end | string collect | tail -n $HIST_DIRS_MAX >"$HIST_DIRS_FILE"
end
