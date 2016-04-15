#!/bin/bash

# using     : build gmp
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
package_name="gmp"
source_file="gmp-6.0.0a.tar.xz"
source_dir="gmp-6.0.0"

# log start
log "$package_name.setup.start" 0

# change working directory to sources directory
cd /sources

# verify
if [ -f $source_file ]; then
    log "$package_name.verify" 0
else
    log "$package_name.verify" 1
fi

# extract source code and change to source directory
if [ -d $source_dir ]; then
    log "$package_name.extract.idle" 0
else
    log "$package_name.extract.start" 0
    tar -vxf $source_file
    log "$package_name.extract.finish" $?
fi
cd $source_dir
ls
# configure
log "$package_name.configure.start" 0
./configure --prefix=/usr    \
   --enable-cxx     \
   --disable-static \
   --docdir=/usr/share/doc/gmp-6.0.0a
log "$package_name.configure.finish" $?

# build
log "$package_name.make.start" 0
make &&
make html
log "$package_name.make.finish" $?

# test
log "$package_name.test.start" 0
make check 2>&1 | tee gmp-check-log &&
awk '/tests passed/{total+=$2} ; END{print total}' gmp-check-log
log "$package_name.test.finish" $?

# install
log "$package_name.install.start" 0
make install &&
make install-html
log "$package_name.install.finish" $?

# successfully
log "$package_name.setup.finish" $?
exit 0
