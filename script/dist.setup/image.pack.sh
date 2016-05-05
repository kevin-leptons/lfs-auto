#!/bin/bash

# using     : compress source into image file
# params    : none
# return    : 0 on success, 1 on error
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# libs
source $script_dir/configuration.sh
source $script_dir/util.sh

# run with lfs user
# file system has own by root
# require root premision to run
require_root

# variables
task_name="dist.image.pack"
dest_file="$dist_dest_dir/lfs-live.amd64.iso"
dest_fs_file="$dist_build_dir/filesystem.squashfs"

step_fs_compress() {
    rm -v $dest_fs_file
    mksquashfs $dist_src_dir $dest_fs_file
}

step_initrd_cp() {
    cp -vp "$dist_src_dir/boot/initrd.img-$kernel_version" $dist_build_dir
}

step_image_pack() {
    rm -rf "$dest_file"
    mkdir -vp $dist_dest_dir
    genisoimage -r -o "$dest_file" \
        -b "syslinux/isolinux.bin" \
        -c "syslinux/boot.cat" \
        -no-emul-boot -boot-load-size 4 -boot-info-table \
        "$dist_build_dir"
}

# run
run_step "$task_name.fs.compress" step_fs_compress force
run_step "$task_name.initrd.cp" step_initrd_cp
run_step "$task_name" step_image_pack force
exit 0
