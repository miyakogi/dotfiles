#!/usr/bin/env bash

if [[ -n `pulsemixer --list-sinks | grep "Name: Firefox" | grep -v "100%"` ]]; then
  echo ""
else
  echo ""
fi