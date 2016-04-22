#!/bin/bash

# using     : entry of box.dev user
#             execute bashrc, and continue process
# author    : kevin.leptons@gmail.com

# working-dir.change
cd /lfs-script
source ~/.bashrc

# libs
source util.sh

# continue process depend on params
case "$1" in

    # transfer control to user under shell
    "box" )
        echo "box.dev.login ok"
        bash;;

    # enter tmp-sys, transfer control to user under shell
    "tmp-sys" )
        pack_state=$(step_state "tmp-sys.setup.finish")
        if [[ $pack_state != "ok" ]]; then
            log "tmp-sys.enter" 1 "tmp-sys.pack.setup.no"
        fi
        bash tmp-sys.entry.sh bash;;

    # enter sys, transfer control to user under shell
    "sys" )
        sys_state=$(step_state "sys.setup.finish")
        if [[ $sys_state != "ok" ]]; then
            log "sys.enter" 1 "sys.setup.no"
        fi
        bash sys.entry.sh bash;;

    # continue setup imediately
    * ) bash setup.sh;;
esac
