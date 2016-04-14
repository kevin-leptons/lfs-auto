#!/bin/bash

# variables
container_name="kevinleptons/lfs-auto"

# build container
# use dockerfile in current directory
docker build -t $container_name ./

# push to container repo
docker push $container_name
