#!/bin/bash

# using     : configure shells
# author    : kevin.leptons@gmail.com

# libs
source util.sh

# variables
task_name="shell.configure"

config_shell() {
    cp -vp asset/etc.shells.sh /etc/shells
}

run_step "$task_name" config_shell
