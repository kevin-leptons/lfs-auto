#!/bin/bash

# using     : download lfs source code, it is packages will build
#             require
#              - ./prepare-partition.sh run successfully
#              - wget-list.txt put int same directory with this script
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"

# use configuration
# use util
source $__dir__/configuration.sh
source $__dir__/util.sh

# define variables
task_name="lfs-source"

# log start

# successfully
log "$task_name.start" true

# download source code from internet
# do not download file if is early exists
wget_list_file=$__dir__/asset/wget-list.txt
mkdir -vp $root_sources
wget -nc --input-file=$wget_list_file --continue \
    --directory-prefix=$root_sources
if [[ $? != 0 ]]; then
    log "$task_name.finish" false
    exit 1
fi

# successfully
log "$task_name.finish" true
exit 0
