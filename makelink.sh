#!/usr/bin/env zsh

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
makedir_if_not_exists $HOME/.vim/backup
makedir_if_not_exists $HOME/.vim/doc
makedir_if_not_exists $HOME/.vim/pack
makedir_if_not_exists $HOME/.vim/pack/remote
makedir_if_not_exists $HOME/.config
makedir_if_not_exists $HOME/.config/kitty
makedir_if_not_exists $HOME/.zsh
makedir_if_not_exists $HOME/.tmux
makedir_if_not_exists $HOME/.tmux/plugins
makedir_if_not_exists $HOME/bin
makedir_if_not_exists $HOME/.percol.d
makedir_if_not_exists $HOME/.cargo

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

# Percol
ln -sf $BASEDIR/percolrc.py $HOME/.percol.d/rc.py

# pip
ln -sf $BASEDIR/scripts/pip-update $HOME/bin/pip-update

# Rust (Cargo)
ln -sf $BASEDIR/cargo.toml $HOME/.cargo/config

# kitty (terminal)
ln -sf $BASEDIR/kitty.conf $HOME/.config/kitty

# Install zaw.sh
git_clone https://github.com/zsh-users/zaw.git  $HOME/.zsh/zaw
# Install zsh-autoenv
git_clone https://github.com/Tarrasch/zsh-autoenv  $HOME/.zsh/zsh-autoenv
# Install compoletions
git_clone https://github.com/zsh-users/zsh-completions.git  $HOME/.zsh/zsh-completions
git_clone https://github.com/bobthecow/git-flow-completion  $HOME/.zsh/git-flow-completion

# Install tpm
git_clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm

# Install pyenv for ubuntu
if [ -e /etc/lsb-release ]; then
  git_clone https://github.com/pyenv/pyenv.git $HOME/.pyenv
fi

echo "Make Link Completed"
