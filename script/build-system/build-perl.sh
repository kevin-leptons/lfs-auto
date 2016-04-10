#!/bin/bash

# using     : build perl
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d perl-5.22.0 ]; then
   tar -xf perl-5.22.0.tar.bz2
fi
cd perl-5.22.0

# create /etc/hosts
echo "127.0.0.1 localhost $(hostname)" > /etc/hosts &&

# make perl use the libraries installed on the system
export BUILD_ZLIB=False
export BUILD_BZIP2=0

# configure
sh Configure -des -Dprefix=/usr                 \
   -Dvendorprefix=/usr           \
   -Dman1dir=/usr/share/man/man1 \
   -Dman3dir=/usr/share/man/man3 \
   -Dpager="/usr/bin/less -isR"  \
   -Duseshrplib &&

# buld
make &&

# test
make -k test &&

# install
make make install &&
unset BUILD_ZLIB BUILD_BZIP2
