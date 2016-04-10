#!/bin/bash

# using     : build kbd
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d kbd-2.0.3 ]; then
   tar -xf kbd-2.0.3.tar.xz
fi
cd kbd-2.0.3

# path
patch -Np1 -i ../kbd-2.0.3-backspace-1.patch &&

# remove the redundant
sed -i 's/\(RESIZECONS_PROGS=\)yes/\1no/g' configure &&
sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in &&

# configure
PKG_CONFIG_PATH=/tools/lib/pkgconfig ./configure \
   --prefix=/usr --disable-vlock &&

# build
make &&

# test
make check &&

# install
make install &&

# install documents
mkdir -v       /usr/share/doc/kbd-2.0.3
cp -R -v docs/doc/* /usr/share/doc/kbd-2.0.3
