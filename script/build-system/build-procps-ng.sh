#!/bin/bash

# using     : build procps-ng
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
package_name="procps-ng"
source_file="procps-ng-3.3.11.tar.xz"
source_dir="procps-ng-3.3.11"

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

# configure
log "$package_name.configure.start" 0
./configure --prefix=/usr                            \
   --exec-prefix=                           \
   --libdir=/usr/lib                        \
   --docdir=/usr/share/doc/procps-ng-3.3.11 \
   --disable-static                         \
   --disable-kill
log "$package_name.configure.finish" $?

# build
log "$package_name.make.start" 0
make
log "$package_name.make.finish" $?

# test
log "$package_name.test.start" 0
sed -i -r 's|(pmap_initname)\\\$|\1|' testsuite/pmap.test/pmap.exp &&
make check
log "$package_name.test.finish" $?

# install
log "$package_name.install.start" 0
make install
log "$package_name.install.finish" $?

# move library
mv -v /usr/lib/libprocps.so.* /lib &&
ln -sfv ../../lib/$(readlink /usr/lib/libprocps.so) /usr/lib/libprocps.so
log "$package_name.lib.move" $?

# successfully
log "$package_name.setup.finish" $?
exit 0
