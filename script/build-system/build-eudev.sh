#!/bin/bash

# using     : build eudev
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
package_name="eudev"
source_file="eudev-3.1.2.tar.gz"
source_dir="eudev-3.1.2"

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

# fix a test script
sed -r -i 's|/usr(/bin/test)|\1|' test/udev-test.pl
log_auto "$package_name.test-script.fix" $?

# prevent the /tools
cat > config.cache << "EOF"
HAVE_BLKID=1
BLKID_LIBS="-lblkid"
BLKID_CFLAGS="-I/tools/include"
EOF
log_auto "/tools.prevent-hard-code-into-eudev". $?

# configure
log_auto "$package_name.configure.start" 0
./configure --prefix=/usr           \
   --bindir=/sbin          \
   --sbindir=/sbin         \
   --libdir=/usr/lib       \
   --sysconfdir=/etc       \
   --libexecdir=/lib       \
   --with-rootprefix=      \
   --with-rootlibdir=/lib  \
   --enable-split-usr      \
   --enable-manpages       \
   --enable-hwdb           \
   --disable-introspection \
   --disable-gudev         \
   --disable-static        \
   --config-cache          \
   --disable-gtk-doc-html
log_auto "$package_name.configure.finish" $?

# build
log_auto "$package_name.make.start" 0
LIBRARY_PATH=/tools/lib make
log_auto "$package_name.make.finish" $?

# create directories are needed for test
mkdir -pv /lib/udev/rules.d &&
mkdir -pv /etc/udev/rules.d
log_auto "$package_name.test.prepare" $?

# test
log_auto "$package_name.test.start" 0
make LD_LIBRARY_PATH=/tools/lib check
log_auto "$package_name.test.finish" $?

# install
log_auto "$package_name.install.start" 0
make LD_LIBRARY_PATH=/tools/lib install
log_auto "$package_name.install.finish" $?

# install custom rules
tar -xvf ../udev-lfs-20140408.tar.bz2 &&
make -f udev-lfs-20140408/Makefile.lfs install
log_auto "$package_name.custom-rule.install" $?

# successfully
log_auto "$package_name.setup.finish" $?
exit 0
