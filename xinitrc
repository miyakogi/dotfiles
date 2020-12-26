#!/usr/bin/env zsh

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

# set qt theme
export QT_QPA_PLATFORMTHEME=qt5ct

# set input method
export XMODIFIERS=@im=fcitx
export GTK_IM_MODULE=xim
export QT_IM_MODULE=fcitx
export GLFW_IM_MODULE=fcitx

# set firefox HW acceleration
export MOZ_X11_EGL=1

case $1 in
  bspwm)
    xsetroot -cursor_name left_ptr
    exec bspwm;;
  i3)
    # need to update config file
    ${XDG_CONFIG_HOME:-$HOME/.config}/i3/update_config.sh
    exec i3;;
  kde)
    export DESKTOP_SESSION=plasma
    exec startplasma-x11;;
  lxqt)
    xsetroot -cursor_name left_ptr
    exec startlxqt;;
  *)
    echo "Unknown WM/DE name: $1, try exec as command."
    exec $1;;
esac
