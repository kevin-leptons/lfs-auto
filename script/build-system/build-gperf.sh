#!/bin/bash

# using     : build gperf
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d gperf-3.0.4 ]; then
   tar -xf gperf-3.0.4.tar.gz
fi
cd gperf-3.0.4

# configure
./configure --prefix=/usr --docdir=/usr/share/doc/gperf-3.0.4 &&

# build
make &&

# test
make -j1 check &&

# install
make install
