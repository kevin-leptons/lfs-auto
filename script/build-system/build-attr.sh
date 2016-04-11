#!/bin/bash

# using     : build attr
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
package_name="attr"
source_file="attr-2.4.47.src.tar.gz"
source_dir="attr-2.4.47"

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

# modify documentation
sed -i -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in &&
sed -i -e "/SUBDIRS/s|man2||" man/Makefile
log_auto "$package_name.documentation.modify" $?

# configure
log_auto "$package_name.configure.start" 0
./configure --prefix=/usr \
   --bindir=/bin \
   --disable-static
log_auto "$package_name.configure.finish" $?

# build
log_auto "$package_name.make.start" 0
make
log_auto "$package_name.make.finish" $?

# test
log_auto "$package_name.test.start" 0
make -j1 tests root-tests
log_auto "$package_name.test.finish" $?

# install
log_auto "$package_name.install.start" 0
make install install-dev install-lib &&
chmod -v 755 /usr/lib/libattr.so
log_auto "$package_name.install.finish" $?

# move library
mv -v /usr/lib/libattr.so.* /lib &&
ln -sfv ../../lib/$(readlink /usr/lib/libattr.so) /usr/lib/libattr.so
log_auto "$package_name.lib.move" $?

# successfully
log_auto "$package_name.setup.finish" $?
exit 0
