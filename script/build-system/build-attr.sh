#!/bin/bash

# using     : build attr
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d attr-2.4.47.src ]; then
   tar -xf attr-2.4.47.src.tar.gz
fi
cd attr-2.4.47

# modify documentation
sed -i -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in
sed -i -e "/SUBDIRS/s|man2||" man/Makefile

# configure
./configure --prefix=/usr \
   --bindir=/bin \
   --disable-static &&

# build
make &&

# test
make -j1 tests root-tests &&

# install
make install install-dev install-lib &&
chmod -v 755 /usr/lib/libattr.so &&

# move library
mv -v /usr/lib/libattr.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libattr.so) /usr/lib/libattr.so
