#!/bin/bash

# using     : build make
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d make-4.1 ]; then
   tar -xf make-4.1.tar.bz2
fi
cd make-4.1

# configure
./configure --prefix=/usr &&

# test
make check &&

# install
make install
