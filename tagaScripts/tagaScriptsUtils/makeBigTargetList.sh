#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

# reinit the files
#rm /tmp/probe2Found.out
#rm /tmp/probe2Notfound.out


let i=255

while [ $i -gt 0 ]
do
   NETADDR=$NETADDRPART.$i
   echo
   echo processing $NETADDR

   list="$list $NETADDR"

   echo $list
   
#   ping -W 1 -c 1 $NETADDR
  
#   if [ $? -eq 0 ]; then
#      echo $NETADDR >> /tmp/probe2Found.out
#   else
#      echo $NETADDR >> /tmp/probe2Notfound.out
#   fi

   let i=$i-1

done

echo $list > largeTargetList.txt



