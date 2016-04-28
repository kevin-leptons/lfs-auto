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
    cp -vp asset/boot.grub.grub.cfg /boot/grub/grub.cfg
}

run_step "$task_name" config_grub
