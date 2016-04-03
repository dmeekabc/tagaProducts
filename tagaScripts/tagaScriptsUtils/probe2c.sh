#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

let i=150

while [ $i -gt 125 ]
do
   NETADDR=$NETADDRPART.$i
   echo
   echo processing $NETADDR
   
   $TAGA_UTILS_DIR/probe2x.sh $NETADDR &

#   ping -W 1 -c 1 $NETADDR
  
#   if [ $? -eq 0 ]; then
#      echo $NETADDR >> /tmp/probe2Found.out
#   else
#      echo $NETADDR >> /tmp/probe2Notfound.out
#   fi
#
   let i=$i-1

done

echo




