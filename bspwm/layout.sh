#!/bin/sh

bspc subscribe report | while read report; do
  case $report in
    *LT*)
      echo "者";;
    *LM*)
      echo "";;
  esac
done
