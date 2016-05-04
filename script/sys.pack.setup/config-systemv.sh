#!/bin/bash

# using     : configure systemv
# author    : kevin.leptons@gmail.com

# libs
source configuration.sh
source util.sh

# variables
task_name="sys.systemv.configure"

step_inittab_cp() {
    cp -vp asset/etc.inittab /etc/inittab
}

step_clock_config() {
    cp -vp asset/etc.sysconfig.clock /etc/sysconfig/clock
}

# run
run_step "$task_name.clock.config" step_clock_config
run_step "$task_name.inittab.cp" step_inittab_cp
