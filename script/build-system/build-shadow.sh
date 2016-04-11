#!/bin/bash

# using     : build shadow
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
package_name="shadow"
source_file="shadow-4.2.1.tar.xz"
source_dir="shadow-4.2.1"

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

# disable the installation of the groups
# coreutils provides a better version
sed -i 's/groups$(EXEEXT) //' src/Makefile.in &&
find man -name Makefile.in -exec sed -i 's/groups\.1 / /' {} \;
log_auto "$package_name.disable-install-group" $?

# use sha-512
sed -i -e 's@#ENCRYPT_METHOD DES@ENCRYPT_METHOD SHA512@' \
   -e 's@/var/spool/mail@/var/mail@' etc/login.defs
log_auto "$package_name.crypto.sha-512.active" $?

# make a minor change to make the default useradd
sed -i 's/1000/999/' etc/useradd
log_auto "$package_name.default-useradd" $?

# configure
log_auto "$package_name.configure.start" 0
./configure --sysconfdir=/etc --with-group-name-max-length=32
log_auto "$package_name.configure.finish" $?

# build
log_auto "$package_name.make.start" 0
make
log_auto "$package_name.make.finish" $?

# install
log_auto "$package_name.install.start" 0
make install
log_auto "$package_name.install.finish" $?

# move executable to its proper location
mv -v /usr/bin/passwd /bin
log_auto "/usr/bin/passwd.move" $?

# enable shadowed passwords
pwconv
log_auto "$package_name.password.enable" $?

# enable shadowed group passwords
grpconv
log_auto "$package_name.group-password.enable" $?

# change password for root user
# todo: this way not work
#echo -e "lfs\nlfs" | passwd root

# successfully
log_auto "$package_name.setup.finish" $?
exit 0
