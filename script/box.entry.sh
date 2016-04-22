#!/bin/bash

# using     : setup inside of box and continues process under dev user
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"

# working-dir.change
cd /lfs-script

# require root permision
./require-root.sh

# libs
source configuration.sh
source util.sh

# variables
task_name="box.inside"

# necessary-dir.mkdir
mkdir -vp /log
mkdir -vp /lfs-script/tmp

# log-files.clear
clear_log
log "$task_name.setup.start" 0

# dev-user.create
./dev-user.create.sh
exit_on_error

# prepare partition
./partition.setup.sh
exit_on_error

# source-code.copy
./source-code.copy.sh

# /lfs-script/tmp.chown
chown lfs:lfs -R /lfs-script/tmp
log "/lfs-script/tmp.chown" $?

# /lfs-script/log.chown
chown lfs:lfs -R /log
log "/lfs-script/log.chown" $?

# box.dev.entry
sudo -u $build_user bash box.dev.entry.sh "$1"
