#!/bin/bash

# using     : box.entry
#             setup inside of box
#             active box.dev
# author    : kevin.leptons@gmail.com

# bash options
set -e

# working-dir.change
cd /lfs-script

# libs
source configuration.sh

# box.dev.setup
./box.dev.setup.sh

# box.dev.pack.verify
./box.dev.pack.verify.sh

# box.partition.setup
./box.dev.partition.setup.sh

# box.dev.active
sudo -u $build_user bash box.dev.entry.sh "$1"
