#!/bin/bash

# using     : prepare every thing, make lfs ready to build
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"

# step 1. preapre partition, where lfs build on
$__dir__/prepare-partition.sh

# step 2. download source code
$__dir__/download-source-code.sh
