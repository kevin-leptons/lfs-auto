#!/bin/bash

# using     : build patch
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd $root_sources

# extract source code and change to source code directory
if [ ! -d patch-2.7.5 ]; then
   tar -xf patch-2.7.5.tar.xz
fi
cd patch-2.7.5

# configure
./configure --prefix=/tools &&

# build
make &&

# test
make check

# install
make install
