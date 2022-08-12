#!/usr/bin/env bash

if systemctl --user status swayidle.service; then
  systemctl --user stop swayidle.service
else
  systemctl --user start swayidle.service
fi
