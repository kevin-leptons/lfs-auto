#!/bin/bash

# using     : build readline
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d readline-6.3 ]; then
   tar -xf readline-6.3.tar.gz
fi
cd readline-6.3

# path
patch -Np1 -i ../readline-6.3-upstream_fixes-3.patch &&

# avoid by issuing the following two seds
sed -i '/MV.*old/d' Makefile.in &&
sed -i '/{OLDSUFF}/c:' support/shlib-install &&

# configure
./configure --prefix=/usr    \
   --disable-static \
   --docdir=/usr/share/doc/readline-6.3 &&

# build
make SHLIB_LIBS=-lncurses &&

# install
make SHLIB_LIBS=-lncurses install &&

# link
mv -v /usr/lib/lib{readline,history}.so.* /lib &&
ln -sfv ../../lib/$(readlink /usr/lib/libreadline.so) /usr/lib/libreadline.so &&
ln -sfv ../../lib/$(readlink /usr/lib/libhistory.so ) /usr/lib/libhistory.so &&

install -v -m644 doc/*.{ps,pdf,html,dvi} /usr/share/doc/readline-6.3

