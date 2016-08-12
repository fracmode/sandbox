#!/bin/bash

timestamp=`date +%Y-%m-%d\ %H:%M:%S`
tmpFile="/tmp/temp"`date +%Y%m%d%H%M%S`

prefix="[${timestamp}] FileSystem Check:"

touch ${tmpFile}

if [ ! -f ${tmpFile} ]; then
    echo "${prefix} FileSystem is Read-Only. Rebooting..."
    reboot
fi

if [ -f ${tmpFile} ]; then
    echo "${prefix} FileSystem is Stable."
    rm -f ${tmpFile}
fi
