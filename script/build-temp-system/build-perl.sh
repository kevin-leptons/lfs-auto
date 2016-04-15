#!/bin/bash

# using     : build perl
# params    : none
# return    : 0 on successfull, 1 on error
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
# use util
source $script_dir/configuration.sh
source $script_dir/util.sh

# define variables
package_name="perl"
source_file="perl-5.22.0.tar.bz2"
source_dir="perl-5.22.0"

# start
log "$package_name.setup.start" 0

# change working directory to sources directory
cd $root_sources

# verify
if [ -f $source_file ]; then
    log "$package_name.verify" 0
else
    log "$package_name.verify" 1
fi

# extract
if [ -d $source_dir ]; then
    log "$package_name.extract.idle" 0
else
    log "$package_name.extract.start" 0
    tar -vxf $source_file
    log "$package_name.extract.finish" $?
fi
cd $source_dir

# configure
log "$package_name.configure.start" 0
sh Configure -des -Dprefix=/tools -Dlibs=-lm
log "$package_name.configure.finish" $?

# build
log "$package_name.make.start" 0
make
log "$package_name.make.finish" $?

# install
log "$package_name.install.start" 0
cp -v perl cpan/podlators/pod2man /tools/bin &&
mkdir -pv /tools/lib/perl5/5.22.0 &&
cp -Rv lib/* /tools/lib/perl5/5.22.0
log "$package_name.install.finish" $?

# successfull
log "$package_name.setup.finish" 0
exit 0
