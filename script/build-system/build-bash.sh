#!/bin/bash

# using     : build bash
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d bash-4.3.30 ]; then
   tar -xf bash-4.3.30.tar.gz
fi
cd bash-4.3.30

# path
patch -Np1 -i ../bash-4.3.30-upstream_fixes-2.patch &&

# configure
./configure --prefix=/usr                       \
   --bindir=/bin                       \
   --docdir=/usr/share/doc/bash-4.3.30 \
   --without-bash-malloc               \
   --with-installed-readline &&

# build
make &&

# prepare test
chown -Rv nobody . &&

# test
su nobody -s /bin/bash -c "PATH=$PATH make tests" &&

# replace bash
exec /bin/bash --login +h
