#!/bin/bash

# using     : setup inside of tmp-sys
# author    : kevin.leptons@gmail.com

# locate location of this script
cd /lfs-script
__dir__="$(dirname "$0")"

# libs
source $__dir__/configuration.sh
source $__dir__/util.sh

# variables
task_name="tmp-sys.inside.setup"

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
        log "tmp-sys.root.login" 0
        exec /tools/bin/bash --login +h;;

    # continue process immediately
    * ) exec /tools/bin/bash /lfs-script/sys.inside.pack.setup.sh --login +h
esac
