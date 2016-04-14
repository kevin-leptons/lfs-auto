#!/bin/bash

# using     : build coreutils
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
package_name="coreutils"
source_file="coreutils-8.24.tar.xz"
source_dir="coreutils-8.24"

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
log_auto "$package_name.patch.start" 0
patch -Np1 -i ../coreutils-8.24-i18n-1.patch &&
sed -i '/tests\/misc\/sort.pl/ d' Makefile.in
log_auto "$package_name.patch.finish" $?

# configure
log_auto "$package_name.configure.start" 0
FORCE_UNSAFE_CONFIGURE=1 ./configure \
   --prefix=/usr            \
   --enable-no-install-program=kill,uptime
log_auto "$package_name.configure.finish" $?

# build
log_auto "$package_name.make.start" 0
make
log_auto "$package_name.make.finish" $?

# test
log_auto "$package_name.root.test.start" 0
make NON_ROOT_USERNAME=nobody check-root
log_auto "$package_name.root.test.finish" $?

# add a temporary group and make the user nobody
echo "dummy:x:1000:nobody" >> /etc/group
log_auto "/etc/group.edit" $?

# fix permission
chown -Rv nobody .
log_auto "nobody.chown" $?

# run test
log_auto "$package_name.nobody.test.start" 0
su nobody -s /bin/bash \
   -c "PATH=$PATH make RUN_EXPENSIVE_TESTS=yes check"
log_auto "$package_name.nobody.test.finish" $?

# remove temporary group
sed -i '/dummy/d' /etc/group
log_auto "/etc/group.remove" $?

# install
log_auto "$package_name.install.start" 0
make install
log_auto "$package_name.install.finish" $?

# move executable file to locations specified by fhs
mv -v /usr/bin/{cat,chgrp,chmod,chown,cp,date,dd,df,echo} /bin &&
mv -v /usr/bin/{false,ln,ls,mkdir,mknod,mv,pwd,rm} /bin &&
mv -v /usr/bin/{rmdir,stty,sync,true,uname} /bin &&
mv -v /usr/bin/chroot /usr/sbin &&
mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8 &&
sed -i s/\"1\"/\"8\"/1 /usr/share/man/man8/chroot.8
mv -v /usr/bin/{head,sleep,nice,test,[} /bin
log_auto "$package_name.executable.move" $?

# successfully
log_auto "$package_name.setup.finish" $?
exit 0
