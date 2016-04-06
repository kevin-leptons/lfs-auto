#!/bin/bash

# using     : build bzip2
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd $root_sources

# extract source code and change to source code directory
if [ ! -d bzip2-1.0.6 ]; then
   tar -xf bzip2-1.0.6.tar.gz 
fi
cd bzip2-1.0.6

# build
make

# install
make PREFIX=/tools install
