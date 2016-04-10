#!/bin/bash

# using     : build intltool
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d intltool-0.51.0 ]; then
   tar -xf intltool-0.51.0.tar.gz
fi
cd intltool-0.51.0

# fix warning
sed -i 's:\\\${:\\\$\\{:' intltool-update.in

# configure
./configure --prefix=/usr &&

# build
make &&

# test
make check &&

# install
make install &&
install -v -Dm644 doc/I18N-HOWTO /usr/share/doc/intltool-0.51.0/I18N-HOWTO
