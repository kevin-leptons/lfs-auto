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
log "$task_name.start" 0

# create user group
groupadd $build_user_group
log "build-group.create" $?

# create user
useradd -s /bin/bash -g $build_user_group -m -k /dev/null $build_user
log "build-user.create" $?

# change user password
echo -e "$build_user_password\n$build_user_password" | passwd $build_user
log "build-user.password.change" $?

# create profile
cp -v $__dir__/asset/build-user-profile.sh $build_user_home/.profile
log "build-user.profile.create" $?

# create bashrc
cp -v $__dir__/asset/build-user-bashrc.sh $build_user_home/.bashrc
log "build-user.bashrc.create" $?

# successfull
log "$task_name.finish" $?
exit 0
