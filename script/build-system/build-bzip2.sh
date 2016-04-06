#!/bin/bash

# using     : build bzip2
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d bzip2-1.0.6 ]; then
   tar -xf bzip2-1.0.6.tar.gz
fi
cd bzip2-1.0.6

# path
patch -Np1 -i ../bzip2-1.0.6-install_docs-1.patch &&
sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile &&
sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile &&

# build preparing
make -f Makefile-libbz2_so &&
make clean &&

# build
make &&

# install
make PREFIX=/usr install &&

# install shared
cp -v bzip2-shared /bin/bzip2
cp -av libbz2.so* /lib
ln -sv ../../lib/libbz2.so.1.0 /usr/lib/libbz2.so
rm -v /usr/bin/{bunzip2,bzcat,bzip2}
ln -sv bzip2 /bin/bunzip2
ln -sv bzip2 /bin/bzcat
