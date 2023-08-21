#!/usr/bin/env bash

if systemctl --user -q is-active quiet swayidle.service; then
  echo -n -e "{ \"text\": \"\u2005\", \"class\": \"Idle\" }"  # U+2005: 1/4 space
else
  echo -n -e "{ \"text\": \"\u2005\", \"class\": \"Info\" }"  # U+2005: 1/4 space
fi
