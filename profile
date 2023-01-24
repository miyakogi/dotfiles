#!/usr/bin/sh
# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
# if [ -n $BASH_VERSION ]; then
#     # include .bashrc if it exists
#     echo "LOAD BASHRC"
#     if [ -f $HOME/.bashrc ]; then
# 	. $HOME/.bashrc
#     fi
# fi

export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

export PATH="$PATH:/sbin"
export PATH="$HOME/bin:$PATH"

if [ -f "$HOME/.profile.local" ]; then
  . "$HOME/.profile.local"
fi

# vim: sw=2 et ft=sh
