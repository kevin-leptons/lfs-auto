#!/bin/bash

# using     : build mpfr
# params    : none
# return    : 0 on success, 1 on error
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
# use util
source $script_dir/configuration.sh
source $script_dir/util.sh

# define variables
package_name="mpfr"
source_file="mpfr-3.1.3.tar.xz"
source_dir="mpfr-3.1.3"

# log start
log_auto "$package_name.setup.start" 0

# change working directory to sources directory
cd /sources

# verify
if [ -f $source_file ]; then
    log_auto "$package_name.verify" 0
else
    log_auto "$package_name.verify" 1
fi

# extract source code and change to source directory
if [ -d $source_dir ]; then
    log_auto "$package_name.extract.idle" 0
else
    log_auto "$package_name.extract.start" 0
    tar -vxf $source_file
    log_auto "$package_name.extract.start" $?
fi
cd $source_dir

# path
log_auto "$package_name.patch.start" 0
patch -Np1 -i ../mpfr-3.1.3-upstream_fixes-1.patch
log_auto "$package_name.patch.finish" $?

# configure
log_auto "$package_name.configure.start" 0
./configure --prefix=/usr        \
   --disable-static     \
   --enable-thread-safe \
   --docdir=/usr/share/doc/mpfr-3.1.3
log_auto "$package_name.configure.finish" $?

# build
log_auto "$package_name.make.start" 0
make &&
make html
log_auto "$package_name.make.finish" $?

# test
log_auto "$package_name.test.start" 0
make check
log_auto "$package_name.test.finish" $?

# install
log_auto "$package_name.install.start" 0
make install &&
make install-html
log_auto "$package_name.install.finish" $?

# successfully
log_auto "$package_name.setup.finish" $?
exit 0
