#!/bin/bash

# using     : build man page
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources

# extract source code and change to source directory
if [ ! -d man-pages-4.02 ]; then
   tar -xf man-pages-4.02.tar.xz
fi
cd man-pages-4.02

# install
make install
