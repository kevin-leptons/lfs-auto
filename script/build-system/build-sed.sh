#!/bin/bash

# using     : build sed
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d sed-4.2.2 ]; then
   tar -xf sed-4.2.2.tar.bz2
fi
cd sed-4.2.2

# configure
./configure --prefix=/usr --bindir=/bin --htmldir=/usr/share/doc/sed-4.2.2 &&

# build
make &&
make html &&

# test
make check &&

# install
make install &&
make -C doc install-html
