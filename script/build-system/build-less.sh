#!/bin/bash

# using     : build less
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d less-458 ]; then
   tar -xf less-458.tar.gz
fi
cd less-458

# configure
./configure --prefix=/usr --sysconfdir=/etc &&

# build
make &&

# install
make install
