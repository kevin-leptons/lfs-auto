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
dest_file="$dist_dest_dir/lfs-live.x64.iso"

step_image_pack() {
    mkdir -vp $dist_dest_dir
    rm -rf "$dest_file"
    genisoimage -r -o "$dest_file" \
        -b "boot/syslinux/isolinux.bin" \
        -c "boot/syslinux/boot.cat" \
        -no-emul-boot -boot-load-size 4 -boot-info-table \
        "$dist_src_dir"
}

# run
run_step "$task_name" step_image_pack
exit 0
