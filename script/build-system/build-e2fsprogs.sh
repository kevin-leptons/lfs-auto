#!/bin/bash

# using     : build e2fsprogs
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d e2fsprogs-1.42.13 ]; then
   tar -xf e2fsprogs-1.42.13.tar.gz
fi
cd e2fsprogs-1.42.13

# create build directory
mkdir -v build
cd build

# configure
LIBS=-L/tools/lib                    \
CFLAGS=-I/tools/include              \
PKG_CONFIG_PATH=/tools/lib/pkgconfig \
../configure --prefix=/usr           \
   --bindir=/bin           \
   --with-root-prefix=""   \
   --enable-elf-shlibs     \
   --disable-libblkid      \
   --disable-libuuid       \
   --disable-uuidd         \
   --disable-fsck &&

# build
make &&

# test
ln -sfv /tools/lib/lib{blk,uu}id.so.1 lib &&
make LD_LIBRARY_PATH=/tools/lib check &&

# install
make install &&

make install-libs &&

chmod -v u+w /usr/lib/{libcom_err,libe2p,libext2fs,libss}.a

gunzip -v /usr/share/info/libext2fs.info.gz &&
install-info --dir-file=/usr/share/info/dir /usr/share/info/libext2fs.info &&

makeinfo -o      doc/com_err.info ../lib/et/com_err.texinfo
install -v -m644 doc/com_err.info /usr/share/info
install-info --dir-file=/usr/share/info/dir /usr/share/info/com_err.info
