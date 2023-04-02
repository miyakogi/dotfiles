#!/usr/bin/env bash

tmp_file="/tmp/ff-volume-fix-paused"

if [ -e "$tmp_file" ]; then
  rm "$tmp_file"
else
  touch "$tmp_file"
fi
