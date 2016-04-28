#!/bin/bash

# using     : entry of box.dev
#             setup inside of box.dev
#             fork process depend on params
# author    : kevin.leptons@gmail.com

# bash options
set -e

# working-dir.change
cd /lfs-script

# libs
source configuration.sh
source util.sh

# update shell
source ~/.bashrc

# create build directories
mkdir -vp "$root_tmp_sources" "$root_sources/system-build"

# continue process depend on params
case "$1" in

    # transfer control to user under shell
    "box" )
        log "box.dev.enter" 0
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
