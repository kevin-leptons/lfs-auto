#!/bin/bash

# using     : build grub
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d grub-2.02 ]; then
   tar -xf grub-2.02~beta2.tar.xz
fi
cd grub-2.02~beta2

# configure
./configure --prefix=/usr          \
   --sbindir=/sbin        \
   --sysconfdir=/etc      \
   --disable-grub-emu-usb \
   --disable-efiemu       \
   --disable-werror &&

# build
make &&

# install
make install
