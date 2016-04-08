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
