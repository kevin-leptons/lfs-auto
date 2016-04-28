#!/bin/bash

# using     : configure grub
# author    : kevin.leptons@gmail.com

# libs
source util.sh

# variables
task_name="grub.configure"

config_grub() {
    # install grub
    grub-install $boot_disk

    # create grub configuration file
    cat > /boot/grub/grub.cfg << "EOF"
    # Begin /boot/grub/grub.cfg
    set default=0
    set timeout=5

    insmod ext2
    set root=(hd3,2)

    menuentry "GNU/Linux, Linux 4.2-lfs-7.8" {
            linux   /boot/vmlinuz-4.2-lfs-7.8 root=/dev/sdc1 ro
    }
    EOF
}

run_step "$task_name" config_grub
