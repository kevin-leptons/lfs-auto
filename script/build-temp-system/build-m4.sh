#!/bin/bash

# using     : build m4
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd $root_sources

# extract source code and change to source code directory
if [ ! -d m4-1.4.17 ]; then
   tar -xf m4-1.4.17.tar.xz
fi
cd m4-1.4.17

# configure
./configure --prefix=/tools &&

# build
make &&

# test
make check

# install
make install
