#!/bin/bash

# using     : build libcap
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
package_name="libcap"
source_file="libcap-2.24.tar.xz"
source_dir="libcap-2.24"

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
    log_auto "$package_name.extract.finish" $?
fi
cd $source_dir

# prevent a static library
sed -i '/install.*STALIBNAME/d' libcap/Makefile
log_auto "$package_name.static-lib.prevent" $?

# build
log_auto "$package_name.make.start" 0
make
log_auto "$package_name.make.finish" $?

# install
log_auto "$package_name.install.start" 0
make RAISE_SETFCAP=no prefix=/usr install &&
chmod -v 755 /usr/lib/libcap.so
log_auto "$package_name.install.finish" $?

# move library
mv -v /usr/lib/libcap.so.* /lib &&
ln -sfv ../../lib/$(readlink /usr/lib/libcap.so) /usr/lib/libcap.so
log_auto "$package_name.lib.move" $?

# successfully
log_auto "$package_name.setup.finish" $?
exit 0
