#!/usr/bin/env bash


###  Detect environment. 
function detect_os() {
    UNAME=`uname -a`

    echo $UNAME | grep -E "Darwin|darwin" &> /dev/null
    if [[ $? == 0 ]]; then 
        RET='darwin'
    fi

    echo $UNAME | grep -E "Ubuntu|Debian|ubuntu|debian" &> /dev/null
    if [[ $? == 0 ]]; then 
        RET='Linux-Debian'
    fi

    echo $UNAME | grep -E "Fedora|CentOS|fedora|centos" &> /dev/null
    if [[ $? == 0 ]]; then 
        RET='Linux-Redhat'
    fi
}

detect_os
OS=$RET

# echo $OS
