#!/bin/bash

# using     : build psmisc
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d psmisc-22.21 ]; then
   tar -xf psmisc-22.21.tar.gz
fi
cd psmisc-22.21

# configure
./configure --prefix=/usr &&

# build
make &&

# install
make install &&

# move executable to the location specified by the fhs
mv -v /usr/bin/fuser   /bin
mv -v /usr/bin/killall /bin
