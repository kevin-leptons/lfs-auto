#!/bin/bash

# using     : build pkg-config
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d pkg-config-0.28 ]; then
   tar -xf pkg-config-0.28.tar.gz
fi
cd pkg-config-0.28

# configure
./configure --prefix=/usr        \
   --with-internal-glib \
   --disable-host-tool  \
   --docdir=/usr/share/doc/pkg-config-0.28 &&

# build
make &&

# test
make check &&

# install
make install
