#!/bin/bash

# using     : build libcap
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d libcap-2.24 ]; then
   tar -xf libcap-2.24.tar.xz
fi
cd libcap-2.24

# prevent a static library
sed -i '/install.*STALIBNAME/d' libcap/Makefile &&

# build
make &&

# install
make RAISE_SETFCAP=no prefix=/usr install &&
chmod -v 755 /usr/lib/libcap.so &&

# move library
mv -v /usr/lib/libcap.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libcap.so) /usr/lib/libcap.so
