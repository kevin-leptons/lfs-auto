#!/bin/bash

# using     : configure network
# author    : kevin.leptons@gmail.com

# libs
source configuration.sh
source util.sh

# variables
task_name="sys.network.configure"

step_ifconfig_cp() {
    cp -vp asset/etc.sysconfig.ifconfig.eth0  /etc/sysconfig/ifconfig.eth0
}

step_resolv_cp() {
    cp -vp asset/etc.resolv.conf /etc/resolv.conf
}

step_hostname_cp() {
    cp -vp asset/etc.hostname /etc/hostname
}

step_hosts_cp() {
    cp -vp asset/etc.hosts /etc/hosts
}

# run
run_step "$task_name.ifconfig.cp" step_ifconfig_cp
run_step "$task_name.resolv.conf.cp" step_resolv_cp
run_step "$task_name.hostname.cp" step_hostname_cp
run_step "$task_name.hosts.cp" step_hosts_cp
