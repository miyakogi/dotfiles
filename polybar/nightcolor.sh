#!/bin/sh

daytemp=6500
nighttemp=4500
temp=$(qdbus org.kde.KWin /ColorCorrect org.kde.kwin.ColorCorrect.currentTemperature)

if [[ $temp -eq $daytemp ]]; then
  echo ""
elif [[ $temp -eq $nighttemp ]]; then
  echo ""
else
  echo "滋"
fi
