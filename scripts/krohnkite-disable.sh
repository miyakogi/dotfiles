#!/bin/sh

# Enable window border and title bar
kwriteconfig5 --file ~/.config/kwinrulesrc --group 3 --key 'types' '4'

# Disable krohnkite
kwriteconfig5 --file ~/.config/kwinrc --group Plugins --key 'krohnkiteEnabled' 'false'

# Reconfigure kwin
qdbus org.kde.KWin /KWin org.kde.KWin.reconfigure
