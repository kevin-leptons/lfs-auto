#!/bin/bash

# using     : prepare packages will use
# author    : kevin.leptons@gmail.com

 # bash options
 set -e

# libs
source config.sh
source util.sh

# variables
task_name="host.pack.setup"
host_packages=( \
    util-linux \
    e2fsprogs \
    docker-engine \
    qemu-kvm \
    libvirt-bin \
    virt-viewer \
)

# start
log "$task_name.start" 0

# install docker-engine repository
# if docker-engine is not installed
# for automated install below
if ! dpkg -s docker-engine > /dev/null 2>&1; then
    sudo apt-get install apt-transport-https ca-certificates
    sudo apt-key adv \
        --keyserver hkp://p80.pool.sks-keyservers.net:80 \
        --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
    sudo cp asset/docker.list /etc/apt/sources.list.d
    apt-cache policy docker-engine
fi

# check for each packages
package_ok=true
for package in "${host_packages[@]}"; do

    if dpkg -s $package > /dev/null 2>&1; then
        log "$package.verify" 0
    else

        # try install package
        log "$package.install.start" 0
        sudo apt-get install -y $package

        # check error
        # error mean that package is not installed
        # successfull mean that package is avaiable on system
        log "$package.install.finish" $?
    fi
done

# libvirt.user.setup
sudo adduser $USER kvm
sudo adduser $USER libvirt

# libvirt.test
virsh --connect qemu:///system list --all

# successfull
log "$task_name.finish" 0
exit 0
