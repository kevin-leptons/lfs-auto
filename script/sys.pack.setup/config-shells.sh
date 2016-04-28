#!/bin/bash

# using     : configure shells
# author    : kevin.leptons@gmail.com

# libs
source util.sh

# variables
task_name="shell.configure"

config_shell() {
    # create /etc/shells
    cat > /etc/shells << "EOF"
    # Begin /etc/shells

    /bin/sh
    /bin/bash

    # End /etc/shells
    EOF
}

run_step "$task_name" config_shell
