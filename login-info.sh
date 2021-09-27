#!/bin/bash

# *************************************************************************
# What is this?
#   Script to print useful system information.
# Usage:
#   To print system info on login, append this file to your .bashrc.
# Note:
#   * You can add any service you'd like to check its status 
#     to the 'serviceStatus' function below
#   * Tested on Ubuntu 20.04 only.
#   * Possible bugs (mainly colors/display bugs).
# *************************************************************************
# Resources:
#   Symbols https://unicode-table.com/en/sets/arrow-symbols/
#   Bash colors: https://misc.flogisoft.com/bash/tip_colors_and_formatting
# *************************************************************************
OS=$(lsb_release -si)
OS_RELEASE=$(lsb_release -sc)
OS_VERSION=$(grep "VERSION_ID" < /etc/os-release | cut -c 13-17)
KERNEL=$(uname -r)
UPTIME=$(uptime -p | sed 's/up//')
ColorReset='\e[0m'
Red='\033[0;31m'
Green='\033[0;32m'
Yellow='\e[93m'
Blue='\E[1;34m'
Dim='\e[2m'
Bold=$(tput bold)
Normal=$(tput sgr0)


function resourcesInfo() {
    echo -e -n "$Dim[Res-Info]"
    USED_SPACE=$(df -H / |  awk '{print $5 }' | sed -e /^Use/d | sed 's/%//' | cut -d "." -f 1)
    SPACE_VERBOSE=$(df -H / |  awk '{print $5 " "$3" of "$2}' | sed -e /^Use/d)
    # I want to perform arithmetic comparison, bash doesn't work with floating points, hence the 'cut' command.
    MEMORY=$(grep MemAvailable < /proc/meminfo | awk '{print $2/1024}' | cut -d "." -f 1)
    LOAD=$(awk '{print "~5 min=" $2}' < /proc/loadavg)

    echo -e -n "$ColorReset""➜ [$Bold$Dim Load Average$ColorReset$Normal$Yellow$Dim $LOAD $ColorReset "

    if [[ $MEMORY -lt 2048 ]] ; then
        echo -e -n "$ColorReset""➜ $Bold$Dim Free Memory$ColorReset$Normal $Red ◉ $MEMORY$ColorReset$Dim MiB $ColorReset "
    else
        echo -e -n "$ColorReset""➜ $Bold$Dim Free Memory$ColorReset$Normal $Green ◉ $MEMORY$ColorReset$Dim MiB $ColorReset "
    fi

    if [[ $USED_SPACE -gt 75 ]] ; then
        echo -e -n "$ColorReset""➜ $Bold$Dim Disk Usage$ColorReset$Normal $Red ◉ $SPACE_VERBOSE $ColorReset]"
    else
        echo -e -n "$ColorReset""➜ $Bold$Dim Disk Usage$ColorReset$Normal $Green ◉ $SPACE_VERBOSE $ColorReset]"
    fi

}

function LoggedInUsers () {
    echo -e -n "$Dim[Users-In]"
    # PROCESSES=$(ps aux | wc -l)
    # echo -e -n $ColorReset"➜ [$Bold$Blue Running Processes$ColorReset$Normal $Yellow ◉ $PROCESSES $ColorReset] "
    # Get logged in users from tty entry:
    # (NR>2) tells awk to skip two header lines
    # sort  and  uniq  to remove duplicate users
    # last sed is to trim/prevent printing whitespaces
    TTY_USERS=$(w | awk '(NR>2) { print $1 }' | sort | uniq | sed '/^[[:space:]]*$/d')
    
    # I'm using echo to utilize -n and -e to force printing mutiline stdout in a single line 
    # because if there're 2+ users logged in, there'd be 2 IP addresses sent out to stdout from the 'w' command
    # ->> awk explanation: skip two headers, print third column, sort, get unique IPs, trim space lines
    TTY_IP=$(echo -n -e "$(w | awk '(NR>2) { print $3 }' | sort | uniq | sed '/^[[:space:]]*$/d')")
    
    echo -e -n "$ColorReset""➜ [$Bold$Dim$ColorReset$Normal$Blue $TTY_USERS$ColorReset$Dim from $Blue$TTY_IP$ColorReset ]"
}

function serviceStatus () {
    SERVICE_STATUS=$(systemctl is-active "$1")
    IS_RUNNING=$(systemctl show -p SubState --value "$1")
    if [ "$SERVICE_STATUS" = "active" ] ; then
    echo -e -n "$ColorReset""➜ [$Bold$Blue $1$ColorReset$Normal $Green ✓$ColorReset$Dim active "

        case $IS_RUNNING in
            "running") echo -e -n "$Green▲$ColorReset$Dim running$Normal$ColorReset ]" ;;
            "dead") echo -e -n "$Red▼$ColorReset$Dim dead$ColorReset ]" ;;
            *) echo -e -n "Error loading service" ;;
        esac

    elif [ "$SERVICE_STATUS" = "inactive" ] ; then
        echo -e -n "$ColorReset""➜ [$Bold$Blue $1$ColorReset$Normal $Red ✗ $ColorReset inactive ] "

    else
        echo -e -n "$ColorReset""➜ [$Bold$Blue $1$ColorReset$Normal $Yellow ● $ColorReset no status! ] "
    fi
}


function sysInfo() {
   echo -e -n "$Dim[Sys-Info]"
   echo -e -n "$ColorReset""➜ [$Dim Uptime$Blue$UPTIME$ColorReset$Dim ★ Kernel$Blue $KERNEL$ColorReset$Dim ★ $OS $Blue$OS_RELEASE-$OS_VERSION $ColorReset] "
}

figlet -w 120 -f slant -k "$HOSTNAME"
LoggedInUsers
echo ""
sysInfo
echo ""
resourcesInfo
echo ""
echo -e -n "$Dim[Services]"
serviceStatus docker
serviceStatus ssh
echo -e "$ColorReset"

# *************************************************************************
