#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

echo; echo $0: Determining GATEWAY....; echo

# allow target list override if any param is provided
if [ $# -eq 1 ]; then
   let USE_ALT_LIST=1
else
   let USE_ALT_LIST=0
fi

#PING_COUNT=10
PING_COUNT=2
SLEEP_TIME=3
SLEEP_TIME=1
SLEEP_TIME=0

MYGATEWAY=$NETADDRPART.1
MYGATEWAY=`route | grep default | cut -c16-30`
echo; echo GATEWAY: $MYGATEWAY

while true
do
   # get the config in case it has changed
   source $TAGA_DIR/config

   if [ $USE_ALT_LIST -eq 1 ]; then
      targetList=$FIXED_ALT_LIST
   fi

   # ping the gateway!
   echo; echo
   echo; echo
   echo PINGING GATEWAY: $MYGATEWAY `date`; echo
   ping -c $PING_COUNT $MYGATEWAY

   sleep $SLEEP_TIME

   echo; echo PINGING TARGETS: $targetList

   for target in $targetList
   do
      echo
      ping -c $PING_COUNT $target
      sleep $SLEEP_TIME
   done

done

