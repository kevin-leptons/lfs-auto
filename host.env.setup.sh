#!/bin/bash

# using     : prepare packages will use
# author    : kevin.leptons@gmail.com

# libs
source config.sh
source util.sh

# define variables
task_name="host-package.prepare"
host_packages=( \
    util-linux \
    e2fsprogs \
    docker-engine \
)

# log start
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

# successfull
log "$task_name.finish" 0
exit 0
