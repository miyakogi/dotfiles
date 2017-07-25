#!/bin/sh

cd vim/src
make distclean
./configure \
	--prefix=/home/takagi/usr \
	--with-features=big \
	--enable-multibyte \
	--enable-terminal \
	--enable-gui=gtk2 \
	--enable-pythoninterp=dynamic \
	--with-python-cofig-dir=/home/takagi/Application/python2.7.11/lib/python2.7/config \
	--enable-python3interp=dynamic \
	--with-python3-cofig-dir=/home/takagi/Application/python3.5.1/lib/python3.5/config-3.5m \
	--enable-luainterp \
	--with-lua-prefix=/usr \
	--with-luajit \
	--enable-gpm \
	--enable-acl \
	--enable-xim \
	--enable-termtruecolor \
	--enable-fail-if-missing


# LDFLAGS="-Wl,-rpath=/opt/python2.7.7-vim/lib:/opt/python3.4.1/lib" \
	# --with-python-config-dir=/opt/python-share/lib/python2.7/config \
	# --with-python3-config-dir=/opt/python-share/lib/python3.3/config-3.3m \
	# --enable-python3interp \
	# --with-python3-config-dir=/usr/lib/python3.3/config \
	# --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu/ \

	# --enable-perlinterp \
	# --enable-tclinterp \
	# --enable-rubyinterp \
	# --enable-cscope \
	# --enable-fontset \
