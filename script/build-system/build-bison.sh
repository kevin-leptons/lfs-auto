#!/bin/bash

# using     : build bison
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d bison-3.0.4 ]; then
   tar -xf bison-3.0.4.tar.xz
fi
cd bison-3.0.4

# configure
./configure --prefix=/usr --docdir=/usr/share/doc/bison-3.0.4 &&

# build
make &&

# test
make check &&

# install
make install
