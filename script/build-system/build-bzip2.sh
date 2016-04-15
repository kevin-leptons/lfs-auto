#!/bin/bash

# using     : build bzip2
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
package_name="bzip2"
source_file="bzip2-1.0.6.tar.gz"
source_dir="bzip2-1.0.6"

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

# path
patch -Np1 -i ../bzip2-1.0.6-install_docs-1.patch &&
sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile &&
sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile
log "$package_name.patch" $?

# prepare
log "$package_name.prepare.start" 0
make -f Makefile-libbz2_so &&
make clean
log "$package_name.prepare.finish" $?

# build
log "$package_name.make.start" 0
make
log "$package_name.make.finish" $?

# install
log "$package_name.install.start" 0
make PREFIX=/usr install
log "$package_name.install.finish" $?

# install shared libraries
cp -v bzip2-shared /bin/bzip2 &&
cp -av libbz2.so* /lib &&
ln -sv ../../lib/libbz2.so.1.0 /usr/lib/libbz2.so &&
rm -v /usr/bin/{bunzip2,bzcat,bzip2} &&
ln -sv bzip2 /bin/bunzip2 &&
ln -sv bzip2 /bin/bzcat
log "$package_name.install-shared-lib" $?

# successfully
log "$package_name.setup.finish" $?
exit 0
