#!/bin/bash

# using     : build file
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d file-5.24 ]; then
   tar -xf file-5.24.tar.gz
fi
cd file-5.24 &&

# configure
./configure --prefix=/usr &&

# build
make &&

# test
make check &&

# install
make install
