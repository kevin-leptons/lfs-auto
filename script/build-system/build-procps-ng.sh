#!/bin/bash

# using     : build procps-ng
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d procps-ng-3.3.11 ]; then
   tar -xf procps-ng-3.3.11.tar.xz
fi
cd procps-ng-3.3.11

# configure
./configure --prefix=/usr                            \
   --exec-prefix=                           \
   --libdir=/usr/lib                        \
   --docdir=/usr/share/doc/procps-ng-3.3.11 \
   --disable-static                         \
   --disable-kill &&

# build
make &&

# test
sed -i -r 's|(pmap_initname)\\\$|\1|' testsuite/pmap.test/pmap.exp &&
make check &&

# install
make install &&

# move library
mv -v /usr/lib/libprocps.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libprocps.so) /usr/lib/libprocps.so
