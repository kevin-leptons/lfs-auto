#!/bin/bash

# using     : build sysklogd
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d sysklogd-1.5.1 ]; then
   tar -xf sysklogd-1.5.1.tar.gz
fi
cd sysklogd-1.5.1

# fix a problem that causes a segmentation fault
sed -i '/Error loading kernel symbols/{n;n;d}' ksym_mod.c &&

# build
make &&

# install
make BINDIR=/sbin install &&

# create /etc/syslog.conf
cat > /etc/syslog.conf << "EOF"
# Begin /etc/syslog.conf

auth,authpriv.* -/var/log/auth.log
*.*;auth,authpriv.none -/var/log/sys.log
daemon.* -/var/log/daemon.log
kern.* -/var/log/kern.log
mail.* -/var/log/mail.log
user.* -/var/log/user.log
*.emerg *

# End /etc/syslog.conf
EOF
