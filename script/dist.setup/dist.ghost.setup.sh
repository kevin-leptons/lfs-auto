#!/bin/bash

# using     : setup direct file system to boot
# params    : none
# return    : 0 on success, 1 on error
# author    : kevin.leptons@gmail.com

# libs
source configuration.sh
source util.sh

# variables
task_name="dist.ghost.setup"
source_file="../syslinux-6.03.tar.gz"
source_dir="syslinux-6.03"
syslinux_dest_dir="$dist_ghost_fs_boot_mnt/boot/syslinux"


# step.image.create 1.5G
step_image_falloc() {
    if [ ! -f  $dist_ghost_fs_boot ]; then
        sudo dd if=/dev/zero of=$dist_ghost_fs_boot bs=1024 count=1572864
    fi
}

# step.syslinux.extract
step_syslinux_extract() {
    if [ ! -d $source_dir ]; then
        tar -vxf $source_file
    fi
}

# step.mbr.install
step_mbr_install() {
    sudo dd if=bios/mbr/mbr.bin of=$dist_ghost_fs_boot bs=440 count=1 conv=notrunc
}

# step.image.partition
step_image_partition() {
    (echo n; echo p; echo 1; echo ""; echo ""; echo a; echo w) \
        | sudo fdisk $dist_ghost_fs_boot
}

# step.image.format
step_image_format() {
    sudo mkfs.ext4 -F $dist_ghost_fs_boot
}

# step.mount
step_image_mount() {
    if ! mount -l | grep $dist_ghost_fs_boot_mnt; then
        sudo mkdir -vp $dist_ghost_fs_boot_mnt
        sudo mount $dist_ghost_fs_boot $dist_ghost_fs_boot_mnt
    fi
}

# step.fs.cp
step_fs_cp() {
    sudo cp -vpru $root/{bin,boot,etc,home,lib,lib64,sbin,usr,var} \
        $dist_ghost_fs_boot_mnt
    sudo mkdir -vp $dist_ghost_fs_boot_mnt/{dev,proc,sys,tmp}
}

# step.syslinux.install
step_syslinux_install() {
    # syslinux.exec.install
    sudo mkdir -vp $syslinux_dest_dir &&
    sudo cp -vpu \
        "bios/core/isolinux.bin" \
        "bios/com32/elflink/ldlinux/ldlinux.c32" \
        /lfs-script/asset/syslinux.ghost/* \
        $syslinux_dest_dir &&

    # mbr.install
    sudo extlinux --install $dist_ghost_fs_boot_mnt &&
    sudo umount $dist_ghost_fs_boot_mnt
}

# run
cd "$root/sources/dist-build"
run_step "$task_name.syslinux.extract" step_syslinux_extract
run_step "$task_name.image.fallocate" step_image_falloc
cd $source_dir
run_step "$task_name.mbr.install" step_mbr_install
run_step "$task_name.image.partition" step_image_partition
run_step "$task_name.image.format" step_image_format
run_step "$task_name.image.mount" step_image_mount force
run_step "$task_name.fs.cp" step_fs_cp force
run_step "$task_name.syslinux.install" step_syslinux_install force
exit 0
