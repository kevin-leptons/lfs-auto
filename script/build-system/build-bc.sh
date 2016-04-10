#!/bin/bash

# using     : build bc
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d bc-1.06.95 ]; then
   tar -xf bc-1.06.95.tar.bz2
fi
cd bc-1.06.95

# path
patch -Np1 -i ../bc-1.06.95-memory_leak-1.patch &&

# configure
./configure --prefix=/usr           \
   --with-readline         \
   --mandir=/usr/share/man \
   --infodir=/usr/share/info &&

# build
make &&

# test
echo "quit" | ./bc/bc -l Test/checklib.b &&

# install
make install
