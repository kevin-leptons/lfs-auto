#!/bin/bash

# using     : create user use to build lfs
# params    : none
# return    : 0 on successfull, 1 on error
# author    : kevin.leptons@gmail.com

# bash options
set -e

# libs
source configuration.sh

# create user group
groupadd $build_user_group

# create user
useradd -s /bin/bash -g $build_user_group -m -k /dev/null $build_user

# change user password
echo -e "$build_user_password\n$build_user_password" | passwd $build_user

# create profile
cp -v asset/build-user-profile.sh $build_user_home/.profile

# create bashrc
cp -v asset/build-user-bashrc.sh $build_user_home/.bashrc

# essential-file-system.create
mkdir -vp log tmp
touch $index_step_file
chown $build_user_group:$build_user log tmp $index_step_file
