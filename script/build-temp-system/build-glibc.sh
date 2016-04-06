#!/bin/bash

# using     : build glibc package
# time      : 4.5 sbu
# params    : none
# return    : 0 on successfull, 1 on error
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
# use util
source $script_dir/configuration.sh
source $script_dir/util.sh

# change working directory to sources directory
cd $root_sources

# define variables
package_name=glibc
source_file=glibc-2.22.tar.xz
source_dir=glibc-2.22
build_dir=glibc-build

# log start setup
log_build "$package_name.setup.start" true

# verify source file
if [ ! -f $source_file ]; then
    log_build "$package_name.vefify" false
    exit 1
else
    log_build "$package_name.vefify" true
fi

# extract source code and change to source code directory
if [ ! -d $source_dir ]; then

    log_build "$package_name.extract.start" true

    tar -vxf $source_file

    if [[ $? != 0 ]]; then
        log_build "$package_name.extract.finish" false
        exit 1
    else
        log_build "$package_name.extract.finish" true
    fi
else
    log_build "$package_name.extract.idle" true
fi
cd $source_dir

# patch
patch_file=../glibc-2.22-upstream_i386_fix-1.patch
patch -Np1 -i $patch_file
if [[ $? != 0 ]]; then
    log_build "$package_name.patch" false
    exit 1
else
    log_build "$package_name.patch" true
fi

# change to source directory and create build directory
cd ../
mkdir -vp $build_dir
cd $build_dir

# configure
log_build "$package_name.configure.start" true
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
if [[ $? != 0 ]]; then
    log_build "$package_name.configure.finish" false
    exit 1
else
    log_build "$package_name.configure.finish" true
fi

# build
log_build "$package_name.make.start" true
make
if [[ $? != 0 ]]; then
    log_build "$package_name.make.finish" false
    exit 1
else
    log_build "$package_name.make.finish" true
fi

# install
log_build "$package_name.install.start" true
make install
if [[ $? != 0 ]]; then
    log_build "$package_name.install.finish" false
    exit 1
else
    log_build "$package_name.install.finish" true
fi

# test
# this is not way to get test result
# todo: make other way to get test result
echo 'int main() {}' > dummy.c
$LFS_TGT-gcc dummy.c
readelf -l a.out | grep '\: /tools'
rm -v dummy.c a.out

# successfull
log_build "$package_name.setup.finish" true
exit 0
