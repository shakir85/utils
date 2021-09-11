
## TODO
## Add Git branch status to PS1
export PS1="\e[1;34m[\e[1;33m\u@\e[1;32m\h\e[1;37m:\w\[\e[1;34m]\e[1;36m\\$ \e[0m"export PS1="\e[1;34m[\e[1;33m\u@\e[1;32mdocker-\h\e[1;37m:\w\[\e[1;34m]\e[1;36m\\$ \e[0m"​
# ------------------------
# Install figlet first!
# ------------------------
# Print system info on shell opening
# add to bash profile
# tested on Ubuntu on Fedora
export OS=$(lsb_release -si)
export OS_RELEASE=$(lsb_release -sc)
export OS_VERSION=$(cat /etc/os-release | grep "VERSION_ID" | cut -c 13-17)
export KERNEL=$(uname -r)
export UPTIME=$(uptime -p)
export HOST=$(hostname)
echo -e -n '\E[1;34m'
figlet -w 120 -f slant -k $HOSTNAME
echo -e "\E[1;36mUptime:\E[1;32m $UPTIME\E[1;36m, Kernel:\E[1;32m $KERNEL\E[1;36m, $OS \E[1;32m $OS_RELEASE $OS_VERSION \E[1;36m"
echo -e -n '\E[1;34m'
echo -e '\E[0m'
