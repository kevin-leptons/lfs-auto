#!/bin/bash

# using     : build eudev
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d eudev-3.1.2 ]; then
   tar -xf eudev-3.1.2.tar.gz
fi
cd eudev-3.1.2

# fix a test script
sed -r -i 's|/usr(/bin/test)|\1|' test/udev-test.pl &&

# prevent the /tools
cat > config.cache << "EOF"
HAVE_BLKID=1
BLKID_LIBS="-lblkid"
BLKID_CFLAGS="-I/tools/include"
EOF

# configure
./configure --prefix=/usr           \
   --bindir=/sbin          \
   --sbindir=/sbin         \
   --libdir=/usr/lib       \
   --sysconfdir=/etc       \
   --libexecdir=/lib       \
   --with-rootprefix=      \
   --with-rootlibdir=/lib  \
   --enable-split-usr      \
   --enable-manpages       \
   --enable-hwdb           \
   --disable-introspection \
   --disable-gudev         \
   --disable-static        \
   --config-cache          \
   --disable-gtk-doc-html &&

# build
LIBRARY_PATH=/tools/lib make &&

# create directories are needed for test
mkdir -pv /lib/udev/rules.d
mkdir -pv /etc/udev/rules.d

# test
make LD_LIBRARY_PATH=/tools/lib check &&

# install
make LD_LIBRARY_PATH=/tools/lib install &&

# install custom rules
tar -xvf ../udev-lfs-20140408.tar.bz2
make -f udev-lfs-20140408/Makefile.lfs install
