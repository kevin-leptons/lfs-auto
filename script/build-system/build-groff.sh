#!/bin/bash

# using     : build groff
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d groff-1.22.3 ]; then
   tar -xf groff-1.22.3.tar.gz
fi
cd groff-1.22.3

# configure
PAGE=A4 ./configure --prefix=/usr &&

# build
make &&

# install
make install
