#!/bin/bash

# using     : build ncurses
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd $root_sources

# extract source code and change to source code directory
if [ ! -d ncurses-6.0 ]; then
   tar -xf ncurses-6.0.tar.gz
fi
cd ncurses-6.0

# prepare
sed -i s/mawk// configure

# configure
./configure --prefix=/tools \
            --with-shared   \
            --without-debug \
            --without-ada   \
            --enable-widec  \
            --enable-overwrite

# build
make

# install
make install
