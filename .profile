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

export PATH=$PATH:/sbin
export PATH=$HOME/bin:$PATH
export PATH=$HOME/usr/bin:$PATH

export GOROOT=/usr/local/go
export PATH=$PATH:$GOROOT/bin
export GOPATH=$HOME/.go
export PATH=$PATH:$GOPATH/bin

export ECLIPSE_HOME=/usr/lib/eclipse
export SCALA_HOME=/usr/share/java
export JAVA_HOME=/usr/lib/jvm/java-7-oracle
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=setting'
export CLASSPATH=.:$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib/dt.jar

export EDITOR=`which vim`

if [ -f $HOME/.profile.local ]; then
  source $HOME/.profile.local
fi
