# using     : configuration of profile for user will use to build
#             it must copy to host:/home/<build-user>/.profile
# author    : kevin.leptons@gmail.com

# when login from host system by 'su <build-user>'
# shell will read host:/etc/profile and make some environment variable from host
# available, it make to build process easy to mistake
# 'exe env' will runing shell with empty environment variable
# then rest command will set some neccessary environemnt variable
# HOME: path to home directory, usually as '/home/<build-user>'
# TERM: shell program will on login session
# PS1: message show on shell
exec env -i HOME=$HOME TERM=$TERM PS1='\u@\h:\W$ ' /bin/bash
