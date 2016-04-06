#!/bin/bash

# using     : build glibc package
# params    : none
# return    : 0 on successfull, 1 on error
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd $root_sources

# define variables
source_file=glibc-2.22.tar.xz
source_dir=glibc-2.22
build_dir=glibc-build

# verify source file
if [ ! -f $source_file ]; then
    echo "erorr: source file " $source_file " is not exist"
    echo $?
    exit 1
fi

# extract source code and change to source code directory
if [ ! -d glibc-2.22 ]; then
   tar -xf glibc-2.22.tar.xz
   if $?; then
       echo "erorr: extract source file " $source_file
       echo $?
       exit 1
   fi
fi
cd glibc-2.22

# patch
patch_file=../glibc-2.22-upstream_i386_fix-1.patch
patch -Np1 -i $patch_file
if $?; then
    echo "erorr: patch source " $patch_file
    echo $?
    exit 1
fi

# change to source directory and create build directory
cd ../
mkdir -vp $build_dir
cd $build_dir

# configure
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
if $?; then
    echo "erorr: configure " $source_file
    echo $?
    exit 1
fi

# build
make
if $?; then
    echo "erorr: make " $source_file
    echo $?
    exit 1
fi

# install
make install
if $?; then
    echo "erorr: install " $source_file
    echo $?
    exit 1
fi

# test
# this is not way to get test result
# todo: make other way to get test result
echo 'int main() {}' > dummy.c
$LFS_TGT-gcc dummy.c
readelf -l a.out | grep '\: /tools'
rm -v dummy.c a.out
