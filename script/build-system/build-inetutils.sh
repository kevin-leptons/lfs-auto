#!/bin/bash

# using     : build inetutils
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d inetutils-1.9.4 ]; then
   tar -xf inetutils-1.9.4.tar.xz
fi
cd inetutils-1.9.4

# configure
./configure --prefix=/usr        \
   --localstatedir=/var \
   --disable-logger     \
   --disable-whois      \
   --disable-rcp        \
   --disable-rexec      \
   --disable-rlogin     \
   --disable-rsh        \
   --disable-servers &&

# build
make &&

# test
make check &&

# install
make install &&

# move executable
mv -v /usr/bin/{hostname,ping,ping6,traceroute} /bin
mv -v /usr/bin/ifconfig /sbin
