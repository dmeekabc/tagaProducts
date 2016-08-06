#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

let PING_SUDO_REQD=1 # Rasperry Pi systems
let PING_SUDO_REQD=0 # Other systems

NETADDR=$1

if [ $PING_SUDO_REQD -eq 1 ]; then
  sudo ping -W 1 -c 1 $NETADDR < $TAGA_CONFIG_DIR/passwd.txt
else
  ping -W 1 -c 1 $NETADDR < $TAGA_CONFIG_DIR/passwd.txt
fi 

if [ $? -eq 0 ]; then
   echo $NETADDR >> /tmp/probe2Found.out
else
   echo $NETADDR >> /tmp/probe2Notfound.out
fi


