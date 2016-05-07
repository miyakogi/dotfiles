#!/bin/sh
BASEDIR=$(cd $(dirname $0);pwd)
echo $BASEDIR

# Make dir if not exists
makedir_if_not_exists () {
    if [ ! -e $1 ]; then
        mkdir $1
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
makedir_if_not_exists $HOME/.vim/bundle
makedir_if_not_exists $HOME/.vim/backup
makedir_if_not_exists $HOME/.vim/pack
makedir_if_not_exists $HOME/.vim/pack/remote
makedir_if_not_exists $HOME/.config
makedir_if_not_exists $HOME/.config/nvim
makedir_if_not_exists $HOME/.config/nvim/bundle
makedir_if_not_exists $HOME/.zsh
makedir_if_not_exists $HOME/bin
makedir_if_not_exists $HOME/.percol.d

# ======== Make Symbolic Link ==============
# ------ Shell ------
ln -sf $BASEDIR/.profile $HOME/.profile
ln -sf $BASEDIR/.zshenv $HOME/.zshenv
ln -sf $BASEDIR/.zsh/.zprofile $HOME/.zsh/.zprofile
ln -sf $BASEDIR/.zsh/.zshrc $HOME/.zsh/.zshrc

# ------ Git ------
ln -sf $BASEDIR/.gitignore_global $HOME/.gitignore_global

# ------ tmux ------
ln -sf $BASEDIR/.tmux.conf $HOME/.tmux.conf

# ------ Vim ------
ln -sf $BASEDIR/.vimrc $HOME/.vimrc
case "${OSTYPE}" in
# Mac(Unix)
darwin*)
    ln -sf $BASEDIR/.gvimrc_mac $HOME/.gvimrc
    ;;
# Linux
linux*)
    ln -sf $BASEDIR/.gvimrc_linux $HOME/.gvimrc
    ;;
esac

ln -sf $BASEDIR/pack.json $HOME/.vim/pack/remote/pack.json
ln -sf $BASEDIR/rgb.txt $HOME/.vim/rgb.txt
ln -sf $BASEDIR/vimpack.py $HOME/bin/vimpack

# Directories for Vim
ln -sf $BASEDIR/after $HOME/.vim
ln -sf $BASEDIR/autoload $HOME/.vim
ln -sf $BASEDIR/colors $HOME/.vim
ln -sf $BASEDIR/config $HOME/.vim
ln -sf $BASEDIR/ftdetect $HOME/.vim
ln -sf $BASEDIR/ftplugin $HOME/.vim
ln -sf $BASEDIR/plugin $HOME/.vim
ln -sf $BASEDIR/snippets $HOME/.vim
ln -sf $BASEDIR/syntax $HOME/.vim

# Directories for NeoVim
NVIMCONFIG=$HOME/.config/nvim
ln -sf $BASEDIR/after $NVIMCONFIG
ln -sf $BASEDIR/autoload $NVIMCONFIG
ln -sf $BASEDIR/colors $NVIMCONFIG
ln -sf $BASEDIR/config $NVIMCONFIG
ln -sf $BASEDIR/ftdetect $NVIMCONFIG
ln -sf $BASEDIR/ftplugin $NVIMCONFIG
ln -sf $BASEDIR/plugin $NVIMCONFIG
ln -sf $BASEDIR/snippets $NVIMCONFIG
ln -sf $BASEDIR/syntax $NVIMCONFIG

# Percol
ln -sf $BASEDIR/percolrc $HOME/.percol.d/rc.py

# Install neobundle.vim for neovim
# git_clone https://github.com/Shougo/neobundle.vim  $HOME/.config/nvim/bundle/neobundle.vim

# Install zaw.sh
git_clone https://github.com/zsh-users/zaw.git  $HOME/.zsh/zaw
# Install zsh-autoenv
git_clone https://github.com/Tarrasch/zsh-autoenv  $HOME/.zsh/zsh-autoenv
# Install compoletions
git_clone https://github.com/zsh-users/zsh-completions.git  $HOME/.zsh/zsh-completions
git_clone https://github.com/bobthecow/git-flow-completion  $HOME/.zsh/git-flow-completion
