#!/bin/bash

# using     : build acl
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d acl-2.2.52 ]; then
   tar -xf acl-2.2.52.src.tar.gz
fi
cd acl-2.2.52

# modify documents
sed -i -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in &&

# fix broken test
sed -i "s:| sed.*::g" test/{sbits-restore,cp,misc}.test &&

# fix bug
sed -i -e "/TABS-1;/a if (x > (TABS-1)) x = (TABS-1);" \
   libacl/__acl_to_any_text.c &&

# configure
./configure --prefix=/usr    \
   --bindir=/bin    \
   --disable-static \
   --libexecdir=/usr/lib &&

# build
make &&

# install
make install install-dev install-lib &&
chmod -v 755 /usr/lib/libacl.so &&

# move library
mv -v /usr/lib/libacl.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libacl.so) /usr/lib/libacl.so
