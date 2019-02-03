#!/bin/bash

function ip_convert () {
    # 8 octets to support up to 8 octets conversion
    conv=({0..1}{0..1}{0..1}{0..1}{0..1}{0..1}{0..1}{0..1})

    # Supports IP with dots (ex. 192.168.0.1) or spaces (192 168 0 1)
    for octet in $( echo ${1} | tr "." " " ); do
        ip="${ip}.${conv[${byte}]}"
    done
    echo ${ip:1}
}

read -rp "Enter the IP address: " ipaddr

# Call conversion function and pass user input IP
ip_convert "$ipaddr"