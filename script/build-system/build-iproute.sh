#!/bin/bash

# using     : build iproute
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d iproute2-4.2.0 ]; then
   tar -xf iproute2-4.2.0.tar.xz
fi
cd iproute2-4.2.0

# prepare
sed -i '/^TARGETS/s@arpd@@g' misc/Makefile &&
sed -i /ARPD/d Makefile &&
sed -i 's/arpd.8//' man/man8/Makefile &&

# build
make &&

# install
make DOCDIR=/usr/share/doc/iproute2-4.2.0 install
