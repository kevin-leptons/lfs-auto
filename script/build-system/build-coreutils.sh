#!/bin/bash

# using     : build coreutils
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d coreutils-8.24 ]; then
   tar -xf coreutils-8.24.tar.xz
fi
cd coreutils-8.24

# path
patch -Np1 -i ../coreutils-8.24-i18n-1.patch &&
sed -i '/tests\/misc\/sort.pl/ d' Makefile.in &&

# configure
FORCE_UNSAFE_CONFIGURE=1 ./configure \
   --prefix=/usr            \
   --enable-no-install-program=kill,uptime &&

# build
make &&

# test
make NON_ROOT_USERNAME=nobody check-root &&

# add a temporary group and make the user nobody
echo "dummy:x:1000:nobody" >> /etc/group

# fix permission
chown -Rv nobody . &&

# run test
su nobody -s /bin/bash \
   -c "PATH=$PATH make RUN_EXPENSIVE_TESTS=yes check"

# remove temporary group
sed -i '/dummy/d' /etc/group &&

# install
make install &&

# move executable file to locations specified by fhs
mv -v /usr/bin/{cat,chgrp,chmod,chown,cp,date,dd,df,echo} /bin
mv -v /usr/bin/{false,ln,ls,mkdir,mknod,mv,pwd,rm} /bin
mv -v /usr/bin/{rmdir,stty,sync,true,uname} /bin
mv -v /usr/bin/chroot /usr/sbin
mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8
sed -i s/\"1\"/\"8\"/1 /usr/share/man/man8/chroot.8

mv -v /usr/bin/{head,sleep,nice,test,[} /bin
