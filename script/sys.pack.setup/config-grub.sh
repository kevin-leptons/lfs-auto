#!/bin/bash

# using     : configure grub
# author    : kevin.leptons@gmail.com

# libs
source configuration.sh
source util.sh

# variables
task_name="grub.configure"

config_grub() {
    # install grub
    grub-install $boot_disk

    # create grub configuration file
    cp -vp asset/boot.grub.grub.cfg /boot/grub/grub.cfg
}

# disable config grub to try boot from hd
# todo: after try boot from hd, enable this
# run_step "$task_name" config_grub
log "$task_name.disable" 0
