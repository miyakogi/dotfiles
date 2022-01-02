#!/usr/bin/env bash

### NightColor support on KWin (LXQt)

daytemp=6500
nighttemp=5200
temp=$(qdbus org.kde.KWin /ColorCorrect org.kde.kwin.ColorCorrect.currentTemperature)

if [[ $temp -eq $daytemp ]]; then
  echo ""
elif [[ $temp -eq $nighttemp ]]; then
  echo ""
else
  echo "滋"
fi
