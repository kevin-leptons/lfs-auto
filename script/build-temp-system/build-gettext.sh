#!/bin/bash

# using     : build gettext
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
package_name="gettext"
source_file="gettext-0.19.5.1.tar.xz"
source_dir="gettext-0.19.5.1"

# start
log_auto "$package_name.setup.start" 0

# change working directory to sources directory
cd $root_sources

# verify
if [ -f $source_file ]; then
    log_auto "$package_name.verify" 0
else
    log_auto "$package_name.verify" 1
fi

# extract
if [ -d $source_dir ]; then
    log_auto "$package_name.extract.idle" 0
else
    log_auto "$package_name.extract.start" 0
    tar -vxf $source_file
    log_auto "$package_name.extract.finish" $?
fi
cd $source_dir/gettext-tools

# configure
log_auto "$package_name.configure.start" 0
EMACS="no" ./configure --prefix=/tools --disable-shared
log_auto "$package_name.configure.finish" $?

# build
log_auto "$package_name.make.start" 0
make -C gnulib-lib &&
make -C intl pluralx.c &&
make -C src msgfmt &&
make -C src msgmerge &&
make -C src xgettext
log_auto "$package_name.make.finish" $?

# install
log_auto "$package_name.install.start" 0
cp -v src/{msgfmt,msgmerge,xgettext} /tools/bin
log_auto "$package_name.install.finish" $?

# successfull
log_auto "$package_name.setup.finish" 0
exit 0
