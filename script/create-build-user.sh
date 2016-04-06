#!/bin/bash

# using     : create user use to build lfs
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"

# require root permision
source $__dir__/require-root.sh

# use configuration
source $__dir__/configuration.sh

# create user group
groupadd $build_user_group

# create user
useradd -s /bin/bash -g $build_user_group -m -k /dev/null $build_user

# change user password
echo -e "$build_user_password\n$build_user_password" | passwd $build_user

# create profile
cp -v $__dir__/asset/build-user-profile.sh $build_user_home/.profile

# create bashrc
cp -v $__dir__/asset/build-user-bashrc.sh $build_user_home/.bashrc
