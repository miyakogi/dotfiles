#!/usr/bin/env bash

if systemctl --user is-active --quiet swayidle.service &>/dev/null; then
  echo -n '{ "text": "", "state": "Idle" }'
else
  echo -n '{ "text": "", "state": "Info" }'
fi
