#!/bin/bash

# using     : build readline
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
package_name="readline"
source_file="readline-6.3.tar.gz"
source_dir="readline-6.3"

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
log "$package_name.patch.start" 0
patch -Np1 -i ../readline-6.3-upstream_fixes-3.patch
log "$package_name.patch.finish" $?

# avoid by issuing the following two seds
sed -i '/MV.*old/d' Makefile.in &&
sed -i '/{OLDSUFF}/c:' support/shlib-install
log "$package_name.issues.avoid" $?

# configure
log "$package_name.configure.start" 0
./configure --prefix=/usr    \
   --disable-static \
   --docdir=/usr/share/doc/readline-6.3
log "$package_name.configure.finish" $?

# build
log "$package_name.make.start" 0
make SHLIB_LIBS=-lncurses
log "$package_name.make.finish" $?

# install
log "$package_name.install.start" 0
make SHLIB_LIBS=-lncurses install
log "$package_name.install.finish" $?

# link
mv -v /usr/lib/lib{readline,history}.so.* /lib &&
ln -sfv ../../lib/$(readlink /usr/lib/libreadline.so) /usr/lib/libreadline.so &&
ln -sfv ../../lib/$(readlink /usr/lib/libhistory.so ) /usr/lib/libhistory.so
log "$package_name.link" $?

install -v -m644 doc/*.{ps,pdf,html,dvi} /usr/share/doc/readline-6.3
log "$package_name.doc.install" $?

# successfully
log "$package_name.setup.finish" $?
exit 0
