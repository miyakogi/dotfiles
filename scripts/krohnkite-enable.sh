#!/bin/sh

# check executables
if ! which kwriteconfig5 > /dev/null || ! which qdbus > /dev/null || wmctrl -m | grep "Name:" | grep -v "KWin" > /dev/null; then
  exit
fi

# Disable window border and title bar
rulesrc="$HOME/.config/kwinrulesrc"
if grep "noborder=true" $rulesrc > /dev/null; then
  count=$(kreadconfig5 --file $rulesrc --group General --key count)
  for i in `seq $count`; do
    # TODO: maybe better to use desctipton field
    if [[ $(kreadconfig5 --file $rulesrc --group $i --key noborder) = "true" ]]; then
      kwriteconfig5 --file $rulesrc --group $i --key 'types' '305'
      break
    fi
  done
fi

# Enable krohnkite
kwinrc="$HOME/.config/kwinrc"
if grep "krohnkiteEnabled" $kwinrc > /dev/null; then
  kwriteconfig5 --file $kwinrc --group Plugins --key 'krohnkiteEnabled' 'true'
fi

# Reconfigure kwin
qdbus org.kde.KWin /KWin org.kde.KWin.reconfigure
