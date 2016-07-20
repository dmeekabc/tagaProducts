#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

# reinit the files
rm /tmp/probe2Found.out    2>/dev/null
rm /tmp/probe2Notfound.out 2>/dev/null


$TAGA_UTILS_DIR/probe2a.sh &
$TAGA_UTILS_DIR/probe2a2.sh &
$TAGA_UTILS_DIR/probe2b.sh &
$TAGA_UTILS_DIR/probe2b2.sh &
$TAGA_UTILS_DIR/probe2c.sh &
$TAGA_UTILS_DIR/probe2c2.sh &
$TAGA_UTILS_DIR/probe2d.sh &
$TAGA_UTILS_DIR/probe2d2.sh &
$TAGA_UTILS_DIR/probe2e.sh &    # this is the one with the output
$TAGA_UTILS_DIR/probe2e2.sh &


exit

let i=255

while [ $i -gt 0 ]
do
   NETADDR=$NETADDRPART.$i
   echo
   echo processing $NETADDR
   
   sudo ping -W 1 -c 1 $NETADDR
  
   if [ $? -eq 0 ]; then
      echo $NETADDR >> /tmp/probe2Found.out
   else
      echo $NETADDR >> /tmp/probe2Notfound.out
   fi

   let i=$i-1

done

echo




