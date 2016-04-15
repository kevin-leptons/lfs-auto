#!/bin/bash

# using     : build glibc package
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

# variables
package_name="glibc"
source_file="glibc-2.22.tar.xz"
source_dir="glibc-2.22"
build_dir="glibc-build"
patch_file="../glibc-2.22-upstream_i386_fix-1.patch"
simple_program_source="/lfs-script/asset/simple-program.c"
simple_program_dest="/lfs-script/tmp/simple-program"

# start
log "$package_name.setup.start" 0

# change working directory to sources directory
cd $root_sources

# verify
if [ -f $source_file ]; then
    log "$package_name.verify" 0
else
    log "$package_name.verify" 1
fi

# extract source code and change to source code directory
if [ -d $source_dir ]; then
    log "$package_name.extract.idle" 0
else
    log "$package_name.extract.start" 0
    tar -vxf $source_file
    log "$package_name.extract.finish" $?
fi
cd $source_dir

# patch
patch -Np1 -i $patch_file
log "$package_name.patch" $?

# change to source directory and create build directory
cd ../
mkdir -vp $build_dir
cd $build_dir

# configure
log "$package_name.configure.start" 0
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
log "$package_name.configure.finish" $?

# build
log "$package_name.make.start" 0
make
log "$package_name.make.finish" $?

# install
log "$package_name.install.start" 0
make install
log "$package_name.install.finish" $?

# test
$LFS_TGT-gcc "$simple_program_source" -o "$simple_program_dest" &&
readelf -l "$simple_program_dest" | grep '\: /tools' | \
    grep "Requesting program interpreter"
log "$package_name.compile" $?

# successfull
log "$package_name.setup.finish" $?
exit 0
