#!/usr/bin/env zsh

BASEDIR=$(cd $(dirname $0);pwd)

# Make dir if not exists
makedir_if_not_exists () {
    if [ ! -e $1 ]; then
        mkdir -p $1
    fi
}

# Delete link if exists
delete_if_exists () {
    if [ -h $1 ]; then
        rm $1
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
makedir_if_not_exists $HOME/.config/alacritty
makedir_if_not_exists $HOME/.config/kitty
makedir_if_not_exists $HOME/.zsh
makedir_if_not_exists $HOME/.tmux/plugins
makedir_if_not_exists $HOME/bin
makedir_if_not_exists $HOME/.percol.d
makedir_if_not_exists $HOME/.cargo
makedir_if_not_exists $HOME/.config/i3
makedir_if_not_exists $HOME/.config/picom
makedir_if_not_exists $HOME/.config/conky
makedir_if_not_exists $HOME/.config/dunst
makedir_if_not_exists $HOME/.config/polybar
makedir_if_not_exists $HOME/.config/rofi

# ======== Make Symbolic Link ==============
# ------ Shell ------
ln -sf $BASEDIR/profile $HOME/.profile
ZSHBASE=$BASEDIR/zsh
# zsh load files this order
ln -sf $ZSHBASE/zshenv $HOME/.zshenv
ln -sf $ZSHBASE/zprofile $HOME/.zsh/.zprofile
ln -sf $ZSHBASE/zshrc $HOME/.zsh/.zshrc
ln -sf $ZSHBASE/prompt $HOME/.zsh/prompt

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

# ------ NeoVim -------
ln -sf $HOME/.vim $HOME/.config/nvim
ln -sf $HOME/.vimrc $HOME/.config/nvim/init.vim

# Percol
ln -sf $BASEDIR/percolrc.py $HOME/.percol.d/rc.py

# pip
ln -sf $BASEDIR/scripts/pip-update $HOME/bin/pip-update

# Rust (Cargo)
ln -sf $BASEDIR/cargo.toml $HOME/.cargo/config

# alacritty (terminal)
ln -sf $BASEDIR/alacritty.yml $HOME/.config/alacritty

# kitty (terminal)
ln -sf $BASEDIR/kitty.conf $HOME/.config/kitty

# i3 window manager
ln -sf $BASEDIR/i3/config $HOME/.config/i3
ln -sf $BASEDIR/i3/lock.sh $HOME/.config/i3
ln -sf $BASEDIR/i3/save_layout.sh $HOME/.config/i3
ln -sf $BASEDIR/i3/load_layout.sh $HOME/.config/i3
ln -sf $BASEDIR/i3/transparent.py $HOME/.config/i3

# picom (compositor)
ln -sf $BASEDIR/picom/picom.conf $HOME/.config/picom

# conky
ln -sf $BASEDIR/conky/conky.conf $HOME/.config/conky
ln -sf $BASEDIR/conky/rings.lua $HOME/.config/conky

# dunst
ln -sf $BASEDIR/dunst/dunstrc $HOME/.config/dunst

# polybar
ln -sf $BASEDIR/polybar/config $HOME/.config/polybar
ln -sf $BASEDIR/polybar/launch.sh $HOME/.config/polybar
ln -sf $BASEDIR/polybar/add_ws.py $HOME/.config/polybar

# rofi
ln -sf $BASEDIR/rofi/config.rasi $HOME/.config/rofi
ln -sf $BASEDIR/rofi/main-theme.rasi $HOME/.config/rofi

# Install zaw.sh
git_clone https://github.com/zsh-users/zaw.git  $HOME/.zsh/zaw
# Install zsh-autoenv
git_clone https://github.com/Tarrasch/zsh-autoenv  $HOME/.zsh/zsh-autoenv
# Install compoletions
git_clone https://github.com/zsh-users/zsh-completions.git  $HOME/.zsh/zsh-completions
git_clone https://github.com/bobthecow/git-flow-completion  $HOME/.zsh/git-flow-completion
# Install zsh-nvm
git_clone https://github.com/lukechilds/zsh-nvm  $HOME/.zsh/zsh-nvm
# Install zsh-autosuggestions
git_clone https://github.com/zsh-users/zsh-autosuggestions  $HOME/.zsh/zsh-autosuggestions

# Install tpm
git_clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm

# Install pyenv for ubuntu
if [ ! -e /etc/arch-release ] && [ -e /etc/lsb-release ]; then
  git_clone https://github.com/pyenv/pyenv.git $HOME/.pyenv
fi

echo "Install Completed"
