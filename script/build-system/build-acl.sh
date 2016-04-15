#!/bin/bash

# using     : build acl
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
package_name="acl"
source_file="acl-2.2.52.src.tar.gz"
source_dir="acl-2.2.52"

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

# modify documents
sed -i -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in
log "$package_name.documents.modify" $?

# fix broken test
sed -i "s:| sed.*::g" test/{sbits-restore,cp,misc}.test
log "$package_name.broken-test.fix" $?

# fix bug
sed -i -e "/TABS-1;/a if (x > (TABS-1)) x = (TABS-1);" \
   libacl/__acl_to_any_text.c
log "$package_name.bug.fix" $?

# configure
log "$package_name.configure.start" 0
./configure --prefix=/usr    \
   --bindir=/bin    \
   --disable-static \
   --libexecdir=/usr/lib
log "$package_name.configure.finish" $?

# build
log "$package_name.make.start" 0
make
log "$package_name.make.finish" $?

# install
log "$package_name.install.start" 0
make install install-dev install-lib &&
chmod -v 755 /usr/lib/libacl.so
log "$package_name.install.finish" $?

# move library
mv -v /usr/lib/libacl.so.* /lib &&
ln -sfv ../../lib/$(readlink /usr/lib/libacl.so) /usr/lib/libacl.so
log "$package_name.lib.move" $?

# successfully
log "$package_name.setup.finish" $?
exit 0
