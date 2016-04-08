#!/bin/bash

# using     : create user use to build lfs
# params    : none
# return    : 0 on successfull, 1 on error
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"

# require root permision
source $__dir__/require-root.sh

# use configuration
# use util
source $__dir__/configuration.sh
source $__dir__/util.sh

# define variables
task_name="create-build-user"

# log start
log "$task_name.start"

# create user group
groupadd $build_user_group
if [[ $? != 0 ]]; then
    log "build-group.create" false
    exit 1
else
    log "build-group.create" true
fi

# create user
useradd -s /bin/bash -g $build_user_group -m -k /dev/null $build_user
if [[ $? != 0 ]]; then
    log "build-user.create" false
    exit 1
else
    log "build-user.create" true
fi

# change user password
echo -e "$build_user_password\n$build_user_password" | passwd $build_user
if [[ $? != 0 ]]; then
    log "build-user.password.change" false
    exit 1
else
    log "build-user.password.change" true
fi

# create profile
cp -v $__dir__/asset/build-user-profile.sh $build_user_home/.profile
echo -e "$build_user_password\n$build_user_password" | passwd $build_user
if [[ $? != 0 ]]; then
    log "build-user.profile.create" false
    exit 1
else
    log "build-user.profile.create" true
fi

# create bashrc
cp -v $__dir__/asset/build-user-bashrc.sh $build_user_home/.bashrc
echo -e "$build_user_password\n$build_user_password" | passwd $build_user
if [[ $? != 0 ]]; then
    log "build-user.bashrc.create" false
    exit 1
else
    log "build-user.bashrc.create" true
fi

# successfull
exit 0
