#!/bin/bash

# using     : build ncurses
# params    : none
# return    : 0 on success, 1 on error
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# define variables
package_name="ncurses"
source_file="ncurses-6.0.tar.gz"
source_dir="ncurses-6.0"

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

# do not install s static library
sed -i '/LIBTOOL_INSTALL/d' c++/Makefile.in
log_auto "$package_name.do-not-install-static-lib" $?

# configure
log_auto "$package_name.configure.start" 0
./configure --prefix=/usr           \
   --mandir=/usr/share/man \
   --with-shared           \
   --without-debug         \
   --without-normal        \
   --enable-pc-files       \
   --enable-widec
log_auto "$package_name.configure.finish" $?

# build
log_auto "$package_name.make.start" 0
make
log_auto "$package_name.make.finish" $?

# install
log_auto "$package_name.install.start" 0
make install
log_auto "$package_name.install.finish" $?

# move library
mv -v /usr/lib/libncursesw.so.6* /lib
log_auto "$package_name.move-lib" $?

# link
ln -sfv ../../lib/$(readlink /usr/lib/libncursesw.so) \
    /usr/lib/libncursesw.so &&

for lib in ncurses form panel menu ; do
   rm -vf                    /usr/lib/lib${lib}.so
   echo "INPUT(-l${lib}w)" > /usr/lib/lib${lib}.so
   ln -sfv ${lib}w.pc        /usr/lib/pkgconfig/${lib}.pc
done

rm -vf                     /usr/lib/libcursesw.so
echo "INPUT(-lncursesw)" > /usr/lib/libcursesw.so
ln -sfv libncurses.so      /usr/lib/libcurses.so

log_auto "$package_name.link" $?

# install documents
mkdir -v       /usr/share/doc/ncurses-6.0 &&
cp -v -R doc/* /usr/share/doc/ncurses-6.0
log_auto "$package_name.insatll-doc" $?

# successfully
log_auto "$package_name.setup.finish" $?
exit 0
