#!/bin/bash

# using     : configure user and software
# author    : kevin.leptons@gmail.com

# libs
source configuration.sh
source util.sh

# variables
task_name="sys.user"

# step.profile
step_profile_config() {
    cp -vpu /lfs-script/asset/user.profile.sh /root/.profile
}

# run
run_step "$task_name.root.profile.cp" step_profile_config
exit 0
