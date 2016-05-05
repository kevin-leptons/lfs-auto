#!/bin/bash

# using     : install initramfs
# params    : none
# return    : 0 on success, 1 on error
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# libs
source $script_dir/configuration.sh
source $script_dir/util.sh

# variables
task_name="sys.initramfs"

# mkinitramfs.cp
step_mkinitramfs_init_cp() {
    mkdir -vp /usr/share/mkinitramfs
    cp -vp /lfs-script/asset/usr.share.mkinitramfs.init.in \
        /usr/share/mkinitramfs/init.in
}

# install
step_install() {
    rm "/boot/initrd.img-$kernel_version"
    $script_dir/mkinitramfs.sh $kernel_version
    mv "initrd.img-$kernel_version" /boot/
}

# run
run_step "$task_name.mkinitramfs.init.cp" step_mkinitramfs_init_cp force
run_step "$task_name.install" step_install force
exit 0
