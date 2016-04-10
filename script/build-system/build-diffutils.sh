#!/bin/bash

# using     : build diffutils
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d diffutils-3.3 ]; then
   tar -xf diffutils-3.3.tar.xz
fi
cd diffutils-3.3

# fix a file so locale file are isntalled
sed -i 's:= @mkdir_p@:= /bin/mkdir -p:' po/Makefile.in.in

# configure
./configure --prefix=/usr &&

# build
make &&

# test
make check &&

# install
make insall
