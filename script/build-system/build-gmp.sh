#!/bin/bash

# using     : build gmp
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d gmp-6.0.0a ]; then
   tar -xf gmp-6.0.0a.tar.xz
fi
cd gmp-6.0.0

# configure
./configure --prefix=/usr    \
   --enable-cxx     \
   --disable-static \
   --docdir=/usr/share/doc/gmp-6.0.0a &&


# build
make &&
make html &&

# test
make check 2>&1 | tee gmp-check-log &&
awk '/tests passed/{total+=$2} ; END{print total}' gmp-check-log

# install
make install &&
make install-html
