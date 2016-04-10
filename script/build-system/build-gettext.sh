#!/bin/bash

# using     : build gettext
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d gettext-0.19.5.1 ]; then
   tar -xf gettext-0.19.5.1.tar.xz
fi
cd gettext-0.19.5.1

# configure
./configure --prefix=/usr    \
   --disable-static \
   --docdir=/usr/share/doc/gettext-0.19.5.1 &&

# build
make &&

# test
make check &&

# install
make install
