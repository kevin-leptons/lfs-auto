#!/bin/bash

# using     : configure network
# author    : kevin.leptons@gmail.com

# libs
source configuration.sh
source util.sh

# variables
task_name="sys.network.configure"

config_network() {
    # create /etc/sysconfig/ifconfig.eth0
    cp -vp asset/etc.sysconfig.ifconfig.eth0  /etc/sysconfig/ifconfig.eth0
}

run_step "$task_name" config_network
