#!/bin/bash

# using     : build perl
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd $root_sources

# extract source code and change to source code directory
if [ ! -d perl-5.22.0 ]; then
   tar -xf perl-5.22.0.tar.bz2
fi
cd perl-5.22.0

# prepare
sh Configure -des -Dprefix=/tools -Dlibs=-lm &&

# build
make &&

# install
cp -v perl cpan/podlators/pod2man /tools/bin &&
mkdir -pv /tools/lib/perl5/5.22.0 && 
cp -Rv lib/* /tools/lib/perl5/5.22.0
