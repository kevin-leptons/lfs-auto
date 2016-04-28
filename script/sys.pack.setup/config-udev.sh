#!/bin/bash

# using     : configure udev
# author    : kevin.leptons@gmail.com

# libs
source configuration.sh
source util.sh

# create custom udev rules
bash /lib/udev/init-net-rules.sh
[ -f /etc/udev/rules.d/70-persistent-net.rules ]
log "udev.config" $?
