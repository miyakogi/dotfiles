#!/usr/bin/env zsh

if [ ! -f $HOME/.rireki.pid ] && which rireki > /dev/null 2>&1
then rireki start
fi
