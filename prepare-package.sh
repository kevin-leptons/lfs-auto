#!/bin/bash

# using     : prepare packages will use
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"

# use configuration
# use util
source $__dir__/script/configuration.sh
source $__dir__/util.sh

# define variables
task_name="host-package.prepare"
host_packages=( \
    util-linux \
    e2fsprogs \
    docker-engine \
)

# log start
log "$task_name.start" true

# install docker-engine repository
# if docker-engine is not installed
# for automated install below
if ! dpkg -s docker-engine > /dev/null 2>&1; then
    sudo apt-get install apt-transport-https ca-certificates
    sudo  apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 \
        --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
    sudo cp asset/docker.list /etc/apt/sources.list.d
    apt-cache policy docker-engine
fi

# check for each packages
package_ok=true
for package in "${host_packages[@]}"; do

    if dpkg -s $package > /dev/null 2>&1; then
        log "$package.verify" true
    else

        # try install package
        log "$package.install.start" true
        sudo apt-get install -y $package

        # check error
        # error mean that package is not installed
        # successfull mean that package is avaiable on system
        if [[ $? != 0 ]]; then
            package_ok=false
            log "$package.install.finish" false
            log "$package.verify" false
        else
            log "$package.install.finish" true
            log "$package.verify" true
        fi
    fi
done

# exit
if [[ $package_ok == true ]]; then
    log "$task_name.finish" true
    exit 0
else
    log "$task_name.finish" false
    exit 1
fi
