#!/bin/bash

# using     : build util-linux
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d util-linux-2.27 ]; then
   tar -xf util-linux-2.27.tar.xz
fi
cd util-linux-2.27

# using /var/lib/hwcloc instead of the usual /etc
mkdir -pv /var/lib/hwclock

# configure
./configure ADJTIME_PATH=/var/lib/hwclock/adjtime   \
   --docdir=/usr/share/doc/util-linux-2.27 \
   --disable-chfn-chsh  \
   --disable-login      \
   --disable-nologin    \
   --disable-su         \
   --disable-setpriv    \
   --disable-runuser    \
   --disable-pylibmount \
   --disable-static     \
   --without-python     \
   --without-systemd    \
   --without-systemdsystemunitdir &&

# build
make &&

# test
chown -Rv nobody . &&
su nobody -s /bin/bash -c "PATH=$PATH make -k check" &&

# install
make install
