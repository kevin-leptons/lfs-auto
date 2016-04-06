#!/bin/bash

# using     : prepare packages will use
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"

# use configuration
source $__dir__/script/configuration.sh

# list all packages
host_packages=( \
    util-linux \
    e2fsprogs \
    docker-engine \
)

# clear log file
> $log_host_package_file

# check for each packages
package_ok=true
for package in "${host_packages[@]}"; do

    state=no

    if dpkg -s $package > /dev/null 2>&1; then
        state=yes
    else
        package_ok=false
    fi

    printf "%-76s %3s\n" $package $state >> $log_host_package_file
done

# show scan result in console
echo "scan packages"
cat $log_host_package_file
if [[ $package_ok == false ]]; then
    echo "error: some package is missing"
    exit 1
else
    echo "package ok"
    exit 0
fi
