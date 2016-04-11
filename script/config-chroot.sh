#!/bin/bash

# using     : config chroot environemnt
# author    : kevin.leptons@gmail.com

# change to lfs-script
cd /lfs-script

# use util
source util.sh

# define variables
task_name="chroot-config"

# log start
log_auto "$task_name.start" 0

# create /bin
# store executable file
mkdir -pv /bin
log_auto "/bin/.create" $?

# create /boot
# store static files of the boot loader
mkdir -pv /boot
log_auto "/boot/.create" $?

# create /etc
# store host-specify system configuration
mkdir -pv /etc/{opt,sysconfig}
log_auto "/etc/.create" $?

# create /home
# store user home directories
mkdir -pv /home
log_auto "/home/.create" $?

# create /lib
# store shared libraries, kernel module
mkdir -pv /lib/firmware
log_auto "/lib/.create" $?

# create /mnt
# store mount point for temporarily mounted
mkdir -pv /mnt
log_auto "/mnt/.create" $?

# create /opt
# store add-on application sortware packages
mkdir -pv /opt
log_auto "/opt/.create" $?

# create /media
# store mount point for removeable media
mkdir -pv /media/{floppy,cdrom}
log_auto "/media/.create" $?

# create /sbin
# store system binaries
mkdir -pv /sbin
log_auto "/sbin/.create" $?

# create /srv
# store data for serivces provided by this system
mkdir -pv /srv
log_auto "/srv/.create" $?

# create /var
# store ?
mkdir -pv /var
log_auto "/var/.create" $?

# create /root
# store home directory of root user
install -dv -m 0750 /root
log_auto "/root/.create" $?

# create /tmp
# store temorary files
install -dv -m 1777 /tmp
log_auto "/tmp/.create" $?

# create /var/tmp
# store temporary files preserved between system reboots
install -dv -m 1777 /var/tmp
log_auto "/var/tmp/.create" $?

# create /usr
# store ?
mkdir -pv /usr/{bin,include,lib,sbin,src}
log_auto "/usr/.create" $?

# create /usr/share
# store architecture-independent data
mkdir -pv /usr/share/{color,dict,doc,info,locale,man,misc,terminfo,zoneinfo}
log_auto "/usr/share/.create" $?

# create /usr/share/man
# store manual page
mkdir -pv /usr/share/man/man{1..8}
log_auto "/usr/share/man/.create" $?

# create /usr/local
# store ?
mkdir -pv /usr/local/{bin,include,lib,sbin,src}
log_auto "/usr/local/.create" $?

# create /usr/local/share
# store local architecture-independent data
mkdir -pv /usr/local/share/{color,dict,doc,info,locale,man,misc,terminfo,\
zoneinfo}
log_auto "/usr/local/share/.create" $?

# create /usr/local/share/man
# store local manual page
mkdir -pv /usr/local/share/man/man{1..8}
log_auto "/usr/local/share/man/.create" $?

# create /usr/libexec
# store binaries run by other programs
mkdir -pv /usr/libexec
log_auto "/usr/libexec/.create" $?

# create /usr/lib64
case $(uname -m) in
    x86_64) \
    ln -svf /lib /lib64
    ln -svf /lib /usr/lib64
    ln -svf /lib /usr/local/lib64;;
esac
log_auto "lib64/.create" $?

# create /var sub directory
# store ?
mkdir -pv /var/{log,mail,spool,opt,cache,local}
log_auto "/var/.sub-dir.create" $?

# create /var/lib
# store variable state information
mkdir -pv /var/lib/{color,misc,locate}
log_auto "/var/lib/.create" $?

# link to /var
ln -svf /run /var/run
ln -svf /run/lock /var/lock
log_auto "/var/.link" $?

# link /tools/bin/ to /bin
ln -svf /tools/bin/{bash,cat,echo,pwd,stty} /bin
log_auto "/tools/bin/.link" $?

# link /tools/bin/perl to /usr/bin
ln -svf /tools/bin/perl /usr/bin
log_auto "/tools/bin/perl.link" $?

# link libgcc to /usr/lib
ln -svf /tools/lib/libgcc_s.so{,..1} /usr/lib
log_auto "/tools/lib/libgcc_s.link" $?

# link libstdc++ to /usr/lib
ln -svf /tools/lib/libstdc++.so{,.6} /usr/lib
log_auto "/tools/lib/libstdc++.link" $?

# link bash to /bin/sh
ln -svf bash /bin/sh
log_auto "/bin/sh.link" $?

# link /proc/self/mounts to /etc/mtab
ln -svf /proc/self/mounts /etc/mtab
log_auto "/etc/mtab.link" $?

# modify libstdc++
sed 's/tools/usr/' /tools/lib/libstdc++.la > /usr/lib/libstdc++.la
log_auto "libstdc++.la.sed" $?

# create password file
cp /lfs-script/asset/passwd /etc/passwd
log_auto "/etc/passwd.create" $?

# create group file
cp /lfs-script/asset/group /etc/group
log_auto "/etc/group.create" $?

# start new bash to get affected from configuration
log_auto "bash.start" 0
exec bash /lfs-script/config-chroot-inside.sh --login +h
log_auto "bash.finish" $?
