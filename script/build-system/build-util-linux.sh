#!/bin/bash

# using     : build util-linux
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

# variables
package_name="util-linux"
source_file="util-linux-2.27.tar.xz"
source_dir="util-linux-2.27"

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

# using /var/lib/hwcloc instead of the usual /etc
mkdir -pv /var/lib/hwclock
log "/var/lib/hscloc.use" $?

# configure
log "$package_name.configure.start" 0
./configure ADJTIME_PATH=/var/lib/hwclock/adjtime   \
   --docdir=/usr/share/doc/util-linux-2.27 \
   --disable-chfn-chsh  \
   --disable-login      \
   --disable-nologin    \
   --disable-su         \
   --disable-setpriv    \
   --disable-runuser    \
   --disable-pylibmount \
   --disable-static     \
   --without-python     \
   --without-systemd    \
   --without-systemdsystemunitdir
log "$package_name.configure.finish" $?

# build
log "$package_name.make.start" 0
make
log "$package_name.make.finish" $?

# test
log "$package_name.test.start" 0
chown -Rv nobody . &&
su nobody -s /bin/bash -c "PATH=$PATH make -k check"
if [[ $? == 0 ]]; then
    log "$package_name.test.finish" 0
else
    log "$package_name.test.fail.allowed" 0
    log "$package_name.test.finish" 0
fi

# install
log "$package_name.install.start" 0
make install
log "$package_name.install.finish" $?

# successfully
log "$package_name.setup.finish" $?
exit 0
