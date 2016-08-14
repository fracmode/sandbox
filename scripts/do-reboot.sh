#!/bin/bash

timestamp=`date +%Y-%m-%d\ %H:%M:%S`
tmpFile="/tmp/temp"`date +%Y%m%d%H%M%S`

prefix="[${timestamp}] FileSystem Check:"

function check_file_system() {
    touch ${tmpFile}

    if [ ! -f ${tmpFile} ]; then
        error_check_file_system
    fi

    if [ -f ${tmpFile} ]; then
        echo "${prefix} FileSystem is Stable."
        rm -f ${tmpFile}
    fi
  
} 

function error_check_file_system() {
    echo "${prefix} FileSystem may be Read-Only. Rebooting..."
    reboot
} 

check_file_system || error_check_file_system
