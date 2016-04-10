#!/bin/bash

# using     : build ncurses
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d ncurses-6.0 ]; then
   tar -xf ncurses-6.0.tar.gz
fi
cd ncurses-6.0

# do not install s static library
sed -i '/LIBTOOL_INSTALL/d' c++/Makefile.in &&

# configure
./configure --prefix=/usr           \
   --mandir=/usr/share/man \
   --with-shared           \
   --without-debug         \
   --without-normal        \
   --enable-pc-files       \
   --enable-widec &&

# build
make &&

# install
make install &&

# move library
mv -v /usr/lib/libncursesw.so.6* /lib

# link 
ln -sfv ../../lib/$(readlink /usr/lib/libncursesw.so) /usr/lib/libncursesw.so

for lib in ncurses form panel menu ; do 
   rm -vf                    /usr/lib/lib${lib}.so
   echo "INPUT(-l${lib}w)" > /usr/lib/lib${lib}.so
   ln -sfv ${lib}w.pc        /usr/lib/pkgconfig/${lib}.pc
done

rm -vf                     /usr/lib/libcursesw.so
echo "INPUT(-lncursesw)" > /usr/lib/libcursesw.so
ln -sfv libncurses.so      /usr/lib/libcurses.so

# install documents
mkdir -v       /usr/share/doc/ncurses-6.0
cp -v -R doc/* /usr/share/doc/ncurses-6.0
