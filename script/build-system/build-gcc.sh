#!/bin/bash

# using     : build gcc
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d gcc-5.2.0 ]; then
   tar -xf gcc-5.2.0.tar.bz2
fi

# create build directory
mkdir -vp gcc-build
cd gcc-build

# configure
SED=sed                       \
../gcc-5.2.0/configure        \
   --prefix=/usr            \
   --enable-languages=c,c++ \
   --disable-multilib       \
   --disable-bootstrap      \
   --with-system-zlib

# build
make

# test
ulimit -s 32768
make -k check
../gcc-5.2.0/contrib/test_summary

# install
make install

# link
ln -sv ../usr/bin/cpp /lib

ln -sv gcc /usr/bin/cc

install -v -dm755 /usr/lib/bfd-plugins
ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/5.2.0/liblto_plugin.so /usr/lib/bfd-plugins/

# test
echo 'int main(){}' > dummy.c
cc dummy.c -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'

grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log

grep -B4 '^ /usr/include' dummy.log

grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'

grep "/lib.*/libc.so.6 " dummy.log

grep found dummy.log

rm -v dummy.c a.out dummy.log

mkdir -pv /usr/share/gdb/auto-load/usr/lib
mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib
