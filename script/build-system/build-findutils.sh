#!/bin/bash

# using     : build findutils
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d findutils-4.4.2 ]; then
   tar -xf findutils-4.4.2.tar.gz
fi
cd findutils-4.4.2

# configure
./configure --prefix=/usr --localstatedir=/var/lib/locate &&

# build
make &&

# test
make check &&

# install
make install &&

# modified correct an explicit path
mv -v /usr/bin/find /bin
sed -i 's|find:=${BINDIR}|find:=/bin|' /usr/bin/updatedb
