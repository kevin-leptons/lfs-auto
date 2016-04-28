#!/bin/bash

# using     : setup inside of system
# author    : kevin.leptons@gmail.com

# locate location of this script
cd /lfs-script
__dir__="$(dirname "$0")"

# libs
source configuration.sh
source util.sh

# variables
task_name="sys.entry"

# unset hash
set +h

# start
log "$task_name.start" 0

# setup
touch /var/log/{btmp,lastlog,wtmp} &&
chgrp -v utmp /var/log/lastlog &&
chmod -v 664  /var/log/lastlog &&
chmod -v 600  /var/log/btmp
log "$task_name.finish" $?

# continue process depend on params
case "$1" in

    # transfer control to user unser shell
    "bash" )
        log "sys.root.login" 0
        exec /tools/bin/bash --login +h;;

    # continue process immediately
    # transfer control to sys.inside.pack.setup.sh
    * ) exec /tools/bin/bash /lfs-script/sys.inside.pack.setup.sh --login +h
esac
