#!/bin/bash

# using     : build mpfr
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d mpfr-3.1.3 ]; then
   tar -xf mpfr-3.1.3.tar.xz
fi
cd mpfr-3.1.3

# path
patch -Np1 -i ../mpfr-3.1.3-upstream_fixes-1.patch &&

# configure
./configure --prefix=/usr        \
   --disable-static     \
   --enable-thread-safe \
   --docdir=/usr/share/doc/mpfr-3.1.3 &&

# build
make &&
make html &&

# test
make check &&

# install
make install &&
make install-html
