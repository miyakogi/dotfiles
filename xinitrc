#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
  xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
  xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
  xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
  xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# start session

export QT_QPA_PLATFORMTHEME=qt5ct
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

case $1 in
  bspwm)
    exec bspwm;;
  i3)
    if [[ ! -e ~/.config/i3/config ]]; then
      cp ~/.config/i3/config.base ~/.config/i3/config
    fi
    exec i3;;
  kde)
    exec startplasma-x11;;
  lxqt)
    exec startlxqt;;
  *)
    echo "Unknown WM/DE name: $1, try exec as command."
    exec $1;;
esac
