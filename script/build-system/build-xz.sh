#!/bin/bash

# using     : build xz
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d xz-5.2.1 ]; then
   tar -xf xz-5.2.1.tar.xz
fi
cd xz-5.2.1

# configure
./configure --prefix=/usr    \
   --disable-static \
   --docdir=/usr/share/doc/xz-5.2.1 &&

# build
make &&

# test
make check &&

# install
make install &&
mv -v   /usr/bin/{lzma,unlzma,lzcat,xz,unxz,xzcat} /bin
mv -v /usr/lib/liblzma.so.* /lib
ln -svf ../../lib/$(readlink /usr/lib/liblzma.so) /usr/lib/liblzma.so
