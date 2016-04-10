#!/bin/bash

# using     : build shadow
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d shadow-4.2.1 ]; then
   tar -xf shadow-4.2.1.tar.xz
fi
cd shadow-4.2.1

# disable the installation of the groups
# coreutils provides a better version
sed -i 's/groups$(EXEEXT) //' src/Makefile.in &&
find man -name Makefile.in -exec sed -i 's/groups\.1 / /' {} \;

# use sha-512
sed -i -e 's@#ENCRYPT_METHOD DES@ENCRYPT_METHOD SHA512@' \
   -e 's@/var/spool/mail@/var/mail@' etc/login.defs &&

# make a minor dhange to make the default useradd
sed -i 's/1000/999/' etc/useradd &&

# configure
./configure --sysconfdir=/etc --with-group-name-max-length=32 &&

# build
make &&

# install
make install &&

# move executable to its proper location
mv -v /usr/bin/passwd /bin

# enable shadowed passwords
pwconv

# enable shadowed group passwords 
grpconv

# change password for root user
# todo: this way not work
#echo -e "lfs\nlfs" | passwd root
