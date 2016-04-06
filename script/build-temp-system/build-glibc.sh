#!/bin/bash

# using     : build glibc package
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd $root_sources

# extract source code and change to source code directory
if [ ! -d glibc-2.22 ]; then
   tar -xf glibc-2.22.tar.xz
fi
cd glibc-2.22 &&

# path package
patch -Np1 -i ../glibc-2.22-upstream_i386_fix-1.patch &&

# change to source directory and create build directory
cd ../
mkdir -vp glibc-build
cd glibc-build

# configure package
../glibc-2.22/configure                             \
      --prefix=/tools                               \
      --host=$LFS_TGT                               \
      --build=$(../glibc-2.22/scripts/config.guess) \
      --disable-profile                             \
      --enable-kernel=2.6.32                        \
      --enable-obsolete-rpc                         \
      --with-headers=/tools/include                 \
      libc_cv_forced_unwind=yes                     \
      libc_cv_ctors_header=yes                      \
      libc_cv_c_cleanup=yes

# build
make

# install
make install

# test
# this is not way to get test result
# todo: make other way to get test result
echo 'int main() {}' > dummy.c
$LFS_TGT-gcc dummy.c
readelf -l a.out | grep '\: /tools'
rm -v dummy.c a.out
