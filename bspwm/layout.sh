#!/usr/bin/env zsh

bspc subscribe report | while read report; do
  case $report in
    *LT*)
      echo "﩯";;
    *LM*)
      echo "";;
  esac
done
