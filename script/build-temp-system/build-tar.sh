#!/bin/bash

# using     : build tar
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd $root_sources

# extract source code and change to source code directory
if [ ! -d tar-1.28 ]; then
   tar -xf tar-1.28.tar.xz
fi
cd tar-1.28

# configure
./configure --prefix=/tools &&

# build
make &&

# test 
make check

# install
make install
