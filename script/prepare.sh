#!/bin/bash

# using     : prepare every thing, make lfs ready to build
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"

# require root permision
source $__dir__/require-root.sh

# step 1. preapre partition, where lfs build on
source $__dir__/prepare-partition.sh

# step 2. download source code
source  $__dir__/download-source-code.sh

