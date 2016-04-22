#!/bin/bash

# using     : clear all build file system
# warning   : run this script in lfs user
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"

# libs
source configuration.sh
source util.sh

# clear tmp-sys directories
./tmp-sys.clear.sh

# clear system directories
./sys.clear.sh

# clear build directories
./build-dir.clear
