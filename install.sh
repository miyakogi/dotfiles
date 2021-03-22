#!/usr/bin/env zsh

BASEDIR=$(cd $(dirname $0);pwd)
CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
ZDOTDIR=${ZDOTDIR:-$HOME/.zsh}

# Make dir if not exists
makedir_if_not_exists () {
  if [ ! -e $1 ]; then
    mkdir -p $1
  fi
}

# git clone if not exist
git_clone () {
  if type git > /dev/null; then
    if [ ! -e $2 ]; then
      git clone $1 $2
    fi
  fi
}

# --- Make Directories ---
makedir_if_not_exists $HOME/.vim
makedir_if_not_exists $HOME/.vim/backup
makedir_if_not_exists $HOME/.vim/doc
makedir_if_not_exists $HOME/.vim/pack/remote
makedir_if_not_exists $CONFIG_HOME/alacritty
makedir_if_not_exists $CONFIG_HOME/kitty
makedir_if_not_exists $CONFIG_HOME/foot
makedir_if_not_exists $ZDOTDIR
makedir_if_not_exists $HOME/.tmux/plugins
makedir_if_not_exists $HOME/bin
makedir_if_not_exists $HOME/.percol.d
makedir_if_not_exists $HOME/.cargo

if [[ $OSTYPE == linux* ]]; then
  makedir_if_not_exists $CONFIG_HOME/pip  # windows use wheel package
  makedir_if_not_exists $CONFIG_HOME/autostart
  makedir_if_not_exists $CONFIG_HOME/i3
  makedir_if_not_exists $CONFIG_HOME/bspwm
  makedir_if_not_exists $CONFIG_HOME/i3/workspaces
  makedir_if_not_exists $CONFIG_HOME/picom
  makedir_if_not_exists $CONFIG_HOME/conky
  makedir_if_not_exists $CONFIG_HOME/dunst
  makedir_if_not_exists $CONFIG_HOME/polybar
  makedir_if_not_exists $CONFIG_HOME/rofi
  makedir_if_not_exists $CONFIG_HOME/autostart-scripts
  makedir_if_not_exists $CONFIG_HOME/plasma-workspace/shutdown
  makedir_if_not_exists $CONFIG_HOME/sway
  makedir_if_not_exists $CONFIG_HOME/mako
  makedir_if_not_exists $CONFIG_HOME/swappy
  makedir_if_not_exists $CONFIG_HOME/waybar

  # wayland screenshot dirs
  makedir_if_not_exists $HOME/Pictures/screenshots/grim
  makedir_if_not_exists $HOME/Pictures/screenshots/swappy
fi

# ======== Make Symbolic Link ==============
# ------ Shell ------
ln -sf $BASEDIR/profile $HOME/.profile
ln -sf $BASEDIR/xinitrc $HOME/.xinitrc
ln -sf $BASEDIR/Xresources $HOME/.Xresources
ln -sf $BASEDIR/Xresources $HOME/.Xdefaults  # for wayland sessions

# zsh load files this order
ZSHBASE=$BASEDIR/zsh
ln -sf $ZSHBASE/zshenv $ZDOTDIR/.zshenv
ln -sf $ZSHBASE/zprofile $ZDOTDIR/.zprofile
ln -sf $ZSHBASE/zshrc $ZDOTDIR/.zshrc
ln -sf $ZSHBASE/prompt.zsh $ZDOTDIR/prompt.zsh

# ------ Git ------
ln -sf $BASEDIR/git/gitignore $HOME/.gitignore_global
ln -sf $BASEDIR/git/gitconfig $HOME/.gitconfig
ln -sf $BASEDIR/git/bin/git-workflow $HOME/bin/

# ------ tmux ------
ln -sf $BASEDIR/tmux.conf $HOME/.tmux.conf

# ------ Vim ------
VIMBASE=$BASEDIR/vim
ln -sf $VIMBASE/vimrc $HOME/.vimrc
case "${OSTYPE}" in
  # Mac(Unix)
  darwin*)
    ln -sf $VIMBASE/gvimrc_mac $HOME/.gvimrc
    ;;
  # Linux
  linux*)
    ln -sf $VIMBASE/gvimrc_linux $HOME/.gvimrc
    ;;
  # Windows
  msys*)
    ln -sf $VIMBASE/gvimrc_win $HOME/.gvimrc
    ;;
esac

ln -sf $VIMBASE/pack.json $HOME/.vim/pack/remote/pack.json
ln -sf $VIMBASE/rgb.txt $HOME/.vim/rgb.txt
ln -sf $VIMBASE/vimpack.py $HOME/bin/vimpack

# Directories for Vim
ln -sf $VIMBASE/after $HOME/.vim
ln -sf $VIMBASE/autoload $HOME/.vim
ln -sf $VIMBASE/colors $HOME/.vim
ln -sf $VIMBASE/config $HOME/.vim
ln -sf $VIMBASE/ftdetect $HOME/.vim
ln -sf $VIMBASE/ftplugin $HOME/.vim
ln -sf $VIMBASE/plugin $HOME/.vim
ln -sf $VIMBASE/snippets $HOME/.vim
ln -sf $VIMBASE/syntax $HOME/.vim

# ------ VimPager ------
ln -sf $VIMBASE/vimpagerrc $HOME/.vim

# ------ NeoVim -------
if [ ! -h $CONFIG_HOME/nvim ]; then
  ln -sf $HOME/.vim $CONFIG_HOME/nvim
fi
ln -sf $HOME/.vimrc $CONFIG_HOME/nvim/init.vim

# Percol
ln -sf $BASEDIR/percolrc.py $HOME/.percol.d/rc.py

# pip
ln -sf $BASEDIR/scripts/pip-update $HOME/bin/pip-update

# Rust (Cargo)
ln -sf $BASEDIR/cargo.toml $HOME/.cargo/config

# starship (prompt)
ln -sf $BASEDIR/starship.toml $CONFIG_HOME/starship.toml

# alacritty (terminal)
ln -sf $BASEDIR/alacritty.yml $CONFIG_HOME/alacritty

# kitty (terminal)
ln -sf $BASEDIR/kitty.conf $CONFIG_HOME/kitty

# foot (terminal)
ln -sf $BASEDIR/foot/foot.ini $CONFIG_HOME/foot/foot.ini

if [[ $OSTYPE == linux* ]]; then
  # pip install --no-binary option
  ln -sf $BASEDIR/pip.conf $CONFIG_HOME/pip

  # autostart script
  ln -sf $BASEDIR/scripts/autostart.sh $HOME/bin/autostart

  # keyboard setup script
  ln -sf $BASEDIR/scripts/keyboard-setup.sh $HOME/bin/keyboard-setup

  # terminal launch script
  ln -sf $BASEDIR/scripts/launch-terminal.sh $HOME/bin/launch-terminal

  # dropdown terminal script
  ln -sf $BASEDIR/scripts/scratchterm-tmux.sh $HOME/bin/scratchterm-tmux

  # screen lock script
  ln -sf $BASEDIR/scripts/lock-screen.sh $HOME/bin/lock-screen

  # i3 window manager
  ln -sf $BASEDIR/i3/config.base $CONFIG_HOME/i3
  ln -sf $BASEDIR/i3/config.gaps $CONFIG_HOME/i3
  ln -sf $BASEDIR/i3/update_config.sh $CONFIG_HOME/i3
  ln -sf $BASEDIR/i3/scratchterm.py $CONFIG_HOME/i3
  ln -sf $BASEDIR/i3/save_layout.sh $CONFIG_HOME/i3
  ln -sf $BASEDIR/i3/load_layouts.sh $CONFIG_HOME/i3
  ln -sf $BASEDIR/i3/addws.py $CONFIG_HOME/i3
  ln -sf $BASEDIR/i3/layout.py $CONFIG_HOME/i3
  ln -sf $BASEDIR/i3/transparent.py $CONFIG_HOME/i3

  # bspwm
  ln -sf $BASEDIR/bspwm/bspwmrc $CONFIG_HOME/bspwm
  ln -sf $BASEDIR/bspwm/sxhkdrc $CONFIG_HOME/bspwm
  ln -sf $BASEDIR/bspwm/layout.sh $CONFIG_HOME/bspwm
  ln -sf $BASEDIR/bspwm/scratchterm.sh $CONFIG_HOME/bspwm

  # picom (compositor)
  ln -sf $BASEDIR/picom/picom.conf $CONFIG_HOME/picom

  # conky
  ln -sf $BASEDIR/conky/conky.conf $CONFIG_HOME/conky
  ln -sf $BASEDIR/conky/rings.lua $CONFIG_HOME/conky

  # dunst
  ln -sf $BASEDIR/dunst/dunstrc $CONFIG_HOME/dunst

  # polybar
  ln -sf $BASEDIR/polybar/config $CONFIG_HOME/polybar
  ln -sf $BASEDIR/polybar/launch.sh $CONFIG_HOME/polybar
  ln -sf $BASEDIR/polybar/rofi-calendar.sh $CONFIG_HOME/polybar
  ln -sf $BASEDIR/polybar/rofi-menu.sh $CONFIG_HOME/polybar
  ln -sf $BASEDIR/polybar/updates.sh $CONFIG_HOME/polybar
  ln -sf $BASEDIR/polybar/nightcolor.sh $CONFIG_HOME/polybar
  ln -sf $BASEDIR/polybar/ff-volume-check.sh $CONFIG_HOME/polybar
  ln -sf $BASEDIR/polybar/ff-volume-fix.sh $CONFIG_HOME/polybar

  # rofi
  ln -sf $BASEDIR/rofi/config.rasi $CONFIG_HOME/rofi
  ln -sf $BASEDIR/rofi/main-theme.rasi $CONFIG_HOME/rofi
  ln -sf $BASEDIR/rofi/menu-theme.rasi $CONFIG_HOME/rofi
  ln -sf $BASEDIR/rofi/menu-theme-gaps.rasi $CONFIG_HOME/rofi
  ln -sf $BASEDIR/rofi/leave-theme.rasi $CONFIG_HOME/rofi
  ln -sf $BASEDIR/rofi/calendar-theme.rasi $CONFIG_HOME/rofi
  ln -sf $BASEDIR/rofi/leave.sh $CONFIG_HOME/rofi

  # sway
  ln -sf $BASEDIR/sway/config $CONFIG_HOME/sway
  ln -sf $BASEDIR/waybar/config $CONFIG_HOME/waybar
  ln -sf $BASEDIR/waybar/style.css $CONFIG_HOME/waybar
  ln -sf $BASEDIR/waybar/launch.sh $CONFIG_HOME/waybar
  ln -sf $BASEDIR/mako/config $CONFIG_HOME/mako
  ln -sf $BASEDIR/swappy/config $CONFIG_HOME/swappy

  # chrome
  # set default flags
  ln -sf $BASEDIR/chrome-flags.conf $CONFIG_HOME
  # startup script
  ln -sf $BASEDIR/scripts/chrome.sh $HOME/bin/chrome.sh

  # kwin/krohnkite
  ln -sf $BASEDIR/scripts/kwin-first-empty.sh $HOME/bin/kwin-first-empty
  ln -sf $BASEDIR/scripts/krohnkite-control.sh $HOME/bin/krohnkite-control

  # kitty mpd music player
  ln -sf $BASEDIR/scripts/kitty-music.sh $HOME/bin/kitty-music

  # plasma
  ln -sf $BASEDIR/scripts/autostart.sh $CONFIG_HOME/autostart-scripts
  ln -sf $BASEDIR/scripts/kde-shutdown.sh $CONFIG_HOME/plasma-workspace/shutdown

  # lxqt
  ln -sf $BASEDIR/autostart/lxqt-autostart.desktop $CONFIG_HOME/autostart
fi

# Install zaw.sh
git_clone https://github.com/zsh-users/zaw.git  $ZDOTDIR/zaw
# Install zsh-autoenv
git_clone https://github.com/Tarrasch/zsh-autoenv  $ZDOTDIR/zsh-autoenv
# Install zsh-compoletions
git_clone https://github.com/zsh-users/zsh-completions.git  $ZDOTDIR/zsh-completions
git_clone https://github.com/bobthecow/git-flow-completion  $ZDOTDIR/git-flow-completion
# Install zsh-nvm
git_clone https://github.com/lukechilds/zsh-nvm  $ZDOTDIR/zsh-nvm
# Install zsh-autosuggestions
git_clone https://github.com/zsh-users/zsh-autosuggestions  $ZDOTDIR/zsh-autosuggestions
# Install zsh-syntax-highlightinh
git_clone https://github.com/zsh-users/zsh-syntax-highlighting  $ZDOTDIR/zsh-syntax-highlighting
# Install zsh-autopair
git_clone https://github.com/hlissner/zsh-autopair $ZDOTDIR/zsh-autopair

# Install tpm
git_clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm

# Install pyenv for ubuntu
if [ ! -e /etc/arch-release ] && [ -e /etc/lsb-release ]; then
  git_clone https://github.com/pyenv/pyenv.git $HOME/.pyenv
fi

echo "Install Completed"
