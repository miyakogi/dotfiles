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
makedir_if_not_exists $HOME/.config
makedir_if_not_exists $HOME/.config/nvim
makedir_if_not_exists $HOME/.config/nvim/bundle
makedir_if_not_exists $HOME/.zsh

# --- Make Symbolic link ---
# Files
ln -sf $BASEDIR/.profile $HOME/.profile
ln -sf $BASEDIR/.vimrc $HOME/.vimrc
ln -sf $BASEDIR/.zshenv $HOME/.zshenv
ln -sf $BASEDIR/.zsh/.zprofile $HOME/.zsh/.zprofile
ln -sf $BASEDIR/.zsh/.zshrc $HOME/.zsh/.zshrc
ln -sf $BASEDIR/rgb.txt $HOME/.vim/rgb.txt
ln -sf $BASEDIR/.tmux.conf $HOME/.tmux.conf
ln -sf $BASEDIR/.gitignore_global $HOME/.gitignore_global

case "${OSTYPE}" in
# Mac(Unix)
darwin*)
    # ここに設定
    ln -sf $BASEDIR/.gvimrc_mac $HOME/.gvimrc
    ;;
# Linux
linux*)
    # ここに設定
    ln -sf $BASEDIR/.gvimrc_linux $HOME/.gvimrc
    ;;
esac

# ======== Directories ==============
# Directories for Vim
ln -sf $BASEDIR/after $HOME/.vim/after
# ln -sf $BASEDIR/autoload $HOME/.vim/autoload
ln -sf $BASEDIR/colors $HOME/.vim/colors
ln -sf $BASEDIR/config $HOME/.vim/config
ln -sf $BASEDIR/ftdetect $HOME/.vim/ftdetect
ln -sf $BASEDIR/ftplugin $HOME/.vim/ftplugin
ln -sf $BASEDIR/pack $HOME/.vim/pack
ln -sf $BASEDIR/plugin $HOME/.vim/plugin
ln -sf $BASEDIR/snippets $HOME/.vim/snippets
ln -sf $BASEDIR/syntax $HOME/.vim/syntax

# Directories for NeoVim
NVIMCONFIG=$HOME/.config/nvim
ln -sf $BASEDIR/after $NVIMCONFIG/after
ln -sf $BASEDIR/colors $NVIMCONFIG/colors
ln -sf $BASEDIR/config $NVIMCONFIG/config
ln -sf $BASEDIR/ftdetect $NVIMCONFIG/ftdetect
ln -sf $BASEDIR/ftplugin $NVIMCONFIG/ftplugin
ln -sf $BASEDIR/plugin $NVIMCONFIG/plugin
ln -sf $BASEDIR/snippets $NVIMCONFIG/snippets
ln -sf $BASEDIR/syntax $NVIMCONFIG/syntax

# Delete links if duplicated
delete_if_exists $NVIMCONFIG/after/after
delete_if_exists $NVIMCONFIG/colors/colors
delete_if_exists $NVIMCONFIG/config/config
delete_if_exists $NVIMCONFIG/ftdetect/ftdetect
delete_if_exists $NVIMCONFIG/ftplugin/ftplugin
delete_if_exists $NVIMCONFIG/plugin/plugin
delete_if_exists $NVIMCONFIG/snippets/snippets
delete_if_exists $NVIMCONFIG/syntax/syntax

# Install neobundle.vim for neovim
# git_clone https://github.com/Shougo/neobundle.vim  $HOME/.config/nvim/bundle/neobundle.vim

# Install zaw.sh
git_clone https://github.com/zsh-users/zaw.git  $HOME/.zsh/zaw
# Install compoletions
git_clone https://github.com/zsh-users/zsh-completions.git  $HOME/.zsh/zsh-completions
git_clone https://github.com/bobthecow/git-flow-completion  $HOME/.zsh/git-flow-completion
