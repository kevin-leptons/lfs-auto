#!/bin/bash

# using     : build expat
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d expat-2.1.0 ]; then
   tar -xf expat-2.1.0.tar.gz
fi
cd expat-2.1.0

# configure
./configure --prefix=/usr --disable-static &&

# build
make &&

# test
make check &&

# install
make install &&

# install documents
install -v -dm755 /usr/share/doc/expat-2.1.0 &&
install -v -m644 doc/*.{html,png,css} /usr/share/doc/expat-2.1.0
