#!/bin/bash

timestamp=`date +%Y-%m-%d\ %H:%M:%S`
tmpFile="/tmp/temp"`date +%Y%m%d%H%M%S`

prefix="[${timestamp}] FileSystem Check:"

mail_from="<MAIL FROM>"
mail_to="<MAIL TO>"
domain="<DOMAIN>"
server_name="<SERVER NAME>"

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
    mail_subject="[${domain}] ${server_name} reboot on ${timestamp}"
    mail_body="ALERT: ${mail_subject}"
    # echo "${prefix} FileSystem may be Read-Only. Rebooting..."
    {
        echo "From: ${mail_from}"
        echo "To: ${mail_to}"
        echo "Subject: ${mail_subject}"
        echo
        echo "${mail_body}"
    } | sendmail -i -f "${mail_from}" "${mail_to}"

    reboot
} 

check_file_system || error_check_file_system
