#!/bin/bash

# using     : configure grub
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# install grub
grub-install $boot_disk

# create grub configuration file
cat > /boot/grub/grub.cfg << "EOF"
# Begin /boot/grub/grub.cfg
set default=0
set timeout=5

insmod ext2
set root=(hd2,2)

menuentry "GNU/Linux, Linux 4.2-lfs-7.8" {
        linux   /boot/vmlinuz-4.2-lfs-7.8 root=/dev/sdc1 ro
}
EOF
