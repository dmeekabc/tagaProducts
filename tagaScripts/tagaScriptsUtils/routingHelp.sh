#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

echo; echo $0 : $MYIP :  executing at `date`; echo

echo; echo
echo "telnet 127.0.0.1 2601  \< password zebra \> "
echo "telnet 127.0.0.1 2602  \< password zebra \> "

echo; echo
echo base commands....
echo list
echo show ip rip status
echo show mem rip 
echo show history

echo; echo
echo drill down commands....

echo enable
echo config t
echo router rip
echo version 2
echo network 192.168.43.0/24




