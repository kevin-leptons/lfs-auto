#!/bin/bash

# using     : build bash
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
package_name="bash"
source_file="bash-4.3.30.tar.gz"
source_dir="bash-4.3.30"

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

# path
patch -Np1 -i ../bash-4.3.30-upstream_fixes-2.patch
log_auto "$package_name.patch" $?

# configure
log_auto "$package_name.configure.start" 0
./configure --prefix=/usr                       \
   --bindir=/bin                       \
   --docdir=/usr/share/doc/bash-4.3.30 \
   --without-bash-malloc               \
   --with-installed-readline
log_auto "$package_name.configure.finish" $?

# build
log_auto "$package_name.make.start" 0
make
log_auto "$package_name.make.finish" $?

# prepare test
chown -Rv nobody .
log_auto "$package_name.tests.prepare" $?

# test
log_auto "$package_name.test.start" 0
su nobody -s /bin/bash -c "PATH=$PATH make tests"
log_auto "$package_name.test.finish" $?

# continue setup with new shell
exec /bin/bash /lfs-script/build-system/build-bc.sh --login +h
