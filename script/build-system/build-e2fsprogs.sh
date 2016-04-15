#!/bin/bash

# using     : build e2fsprogs
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
package_name="e2fsprogs"
source_file="e2fsprogs-1.42.13.tar.gz"
source_dir="e2fsprogs-1.42.13"

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

# create build directory
mkdir -vp build
cd build

# configure
log "$package_name.configure.start" 0
LIBS=-L/tools/lib                    \
CFLAGS=-I/tools/include              \
PKG_CONFIG_PATH=/tools/lib/pkgconfig \
../configure --prefix=/usr           \
   --bindir=/bin           \
   --with-root-prefix=""   \
   --enable-elf-shlibs     \
   --disable-libblkid      \
   --disable-libuuid       \
   --disable-uuidd         \
   --disable-fsck
log "$package_name.configure.finish" $?

# build
log "$package_name.make.start" 0
make
log "$package_name.make.finish" $?

# test
log "$package_name.test.start" 0
ln -sfv /tools/lib/lib{blk,uu}id.so.1 lib &&
make LD_LIBRARY_PATH=/tools/lib check
log "$package_name.test.finish" $?

# install
log "$package_name.install.start" 0
make install
log "$package_name.install.finish" $?

make install-libs
log "$package_name.lib.install" $?

chmod -v u+w /usr/lib/{libcom_err,libe2p,libext2fs,libss}.a
log "$package_name.lib.chmod" $?

gunzip -v /usr/share/info/libext2fs.info.gz &&
install-info --dir-file=/usr/share/info/dir /usr/share/info/libext2fs.info
log "$package_name.info.install" $?

makeinfo -o      doc/com_err.info ../lib/et/com_err.texinfo &&
install -v -m644 doc/com_err.info /usr/share/info &&
install-info --dir-file=/usr/share/info/dir /usr/share/info/com_err.info
log "$package_name.doc.install" $?

# successfully
log "$package_name.setup.finish" $?
exit 0
