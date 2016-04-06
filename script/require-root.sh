#!/bin/bash

# using     : valid script run as root
#             it use in head of other script to warning that script must run as
#             root
# author    : kevin.leptons@gmail.com

if [ "$(id -u)" != "0" ]; then
    echo "error: the script must be run as root"
    exit 1
fi
