#!/bin/bash

# using     : try run install image by virtual machine
# author    : kevin.leptons@gmail.com

# bash options
set -e

# variables
vm_type="kvm"
vm_name="lfs-live.amd64"
vm_cpus="2"
vm_ram="512"
vm_cdrom="/mnt/lfs/dist/dest/lfs-live.amd64.iso"
vm_disk_path="disk/lfs-live.amd64.vm.img"
vm_disk_size="8"

# handle for exit event
on_exit() {
    echo "stop vm.$vm_name"
    virsh destroy $vm_name
}

# shen exit script, kill virtual machine
trap on_exit EXIT

# mount build image\
if ! mount -l | grep /mnt/lfs; then
    sudo mount "disk/lfs-disk.img" "/mnt/lfs"
fi

# remove early virtual machine
if virsh list --all | grep $vm_name; then
    virsh destroy $vm_name
    virsh undefine $vm_name
fi

# install, show on window
virt-install \
    --virt-type $vm_type \
    --name $vm_name \
    --vcpus $vm_cpus \
    --ram $vm_ram \
    --cdrom $vm_cdrom \
    --disk path=$vm_disk_path,size=$vm_disk_size
