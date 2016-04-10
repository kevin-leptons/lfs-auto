#!/bin/bash

# using     : build iana-etc
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d iana-etc-2.30 ]; then
   tar -xf iana-etc-2.30.tar.bz2
fi
cd iana-etc-2.30

# build
make &&

# install
make install
