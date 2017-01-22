#!/bin/bash

# Author: Kali

prefix="MONITORIX_ROOTDIR"

# Stop monitorix first
count=`docker ps | grep monitorix | wc -l`
if [ $count -gt 0 ];
then
    docker stop monitorix
    docker rm monitorix
fi

# Pass any argument for batch run
clean=0
if [ $# -eq 1 ] && [ "$1" == "cleanup" ];
then
    echo "Cleanup all png, rrd files and index.html page"
    find $prefix/files/monitorix/www/imgs/ -maxdepth 1 -type f -name "*.png" -delete
    find $prefix/files/monitorix/ -maxdepth 1 -type f -name "*.rrd" -delete
    rm -f $prefix/files/monitorix/www/index.html 
fi

# Start monitorix
docker run \
    -d \
    --privileged=true \
    --name monitorix \
    --net host \
    -v $prefix/config/monitorix.conf:/etc/monitorix/monitorix.conf \
    -v $prefix/files:/var/lib:rw \
    docker.io/akaliwod/monitorix:latest

