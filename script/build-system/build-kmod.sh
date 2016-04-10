#!/bin/bash

# using     : build kmod
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d kmod-21 ]; then
   tar -xf kmod-21.tar.xz
fi
cd kmod-21

# configure
./configure --prefix=/usr          \
   --bindir=/bin          \
   --sysconfdir=/etc      \
   --with-rootlibdir=/lib \
   --with-xz              \
   --with-zlib &&

# build
make &&

# install
make install &&

for target in depmod insmod lsmod modinfo modprobe rmmod; do
   ln -sv ../bin/kmod /sbin/$target
done

ln -sv kmod /bin/lsmod
