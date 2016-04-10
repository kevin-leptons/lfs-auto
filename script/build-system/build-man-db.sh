#!/bin/bash

# using     : build man-db
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d man-db-2.7.2 ]; then
   tar -xf man-db-2.7.2.tar.xz
fi
cd man-db-2.7.2

# configure
./configure --prefix=/usr                        \
   --docdir=/usr/share/doc/man-db-2.7.2 \
   --sysconfdir=/etc                    \
   --disable-setuid                     \
   --with-browser=/usr/bin/lynx         \
   --with-vgrind=/usr/bin/vgrind        \
   --with-grap=/usr/bin/grap &&

# build
make &&

# test
make check &&

# install
make install


