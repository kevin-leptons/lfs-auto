#!/bin/bash

# using     : build tcl-core
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd $root_sources

# extract source code and change to source directory
if [ ! -d tcl8.6.4 ]; then
   tar -xf tcl-core8.6.4-src.tar.gz
fi
cd tcl8.6.4

# prepare
cd unix
./configure --prefix=/tools

# build
make

# test
TZ=UTC make test

# install
make install

# make library writeable, so can removed later
chmod -v u+x /tools/lib/libtcl8.6.so

# install tcl headers
make install-private-headers

# link
ln -sv tclsh8.6 /tools/bin/tclsh
