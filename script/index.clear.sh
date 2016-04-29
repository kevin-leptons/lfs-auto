#!/bin/bash

# using     : clean index of setup process
# warning   : run this script in lfs user
# author    : kevin.leptons@gmail.com

cd /lfs-script

# libs
source configuration.sh
source util.sh

rm -vrf tmp/* log/*
log "index.clear" $?
