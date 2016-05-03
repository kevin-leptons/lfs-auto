#!/bin/bash

# using     : switch between activation of virtual machine
# params    :
#   $1      : active distribution name
#    - ghost: active with ghost distribution
#    - live: active with live distribution
# author    : kevin.leptons@gmail.com

# bash options
set -e

case $1 in
    "ghost" )
        ./vm.ghost.active.sh
        ;;
    "live" )
        ./vm.live.active.sh
        ;;
    * )
        (>&2 echo distribution is not specify)
        exit 1
esac
