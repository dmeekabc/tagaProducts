#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

# method to determine gateway name
GW_DETERMINATINO_METHOD="runtime"
GW_DETERMINATINO_METHOD="config"

# allow target list override if any param is provided
if [ $# -eq 1 ]; then
   let USE_ALT_LIST=1
else
   let USE_ALT_LIST=0
fi

PING_COUNT=2
SLEEP_TIME=1
SLEEP_TIME=0

echo; echo $0 : $MYIP :  executing at `date`

#echo; echo $0: Determining GATEWAY....; echo
#MYGATEWAY=`route | grep default | cut -c16-30`
#echo GATEWAY: $MYGATEWAY

while true
do
   # get the config in case it has changed
   source $TAGA_CONFIG_DIR/config

   # get the gateway in case it has changed
   echo; date; echo Determining GATEWAY....

   if [ $GW_DETERMINATINO_METHOD == "runtime" ] ; then
      # get gateway via runtime check
      MYGATEWAY=`route | grep default | cut -c16-30`
   else
      # get gateway via config
      MYGATEWAY=$NETADDRPART.1
   fi
   echo GATEWAY: $MYGATEWAY
   exit

   if [ $USE_ALT_LIST -eq 1 ]; then
      targetList=$FIXED_ALT_LIST
   fi

   # ping the gateway
   echo; echo PINGING GATEWAY: $MYGATEWAY; echo
   ping -c $PING_COUNT $MYGATEWAY
   sleep $SLEEP_TIME

   # ping the targets
   echo; date
   echo PINGING TARGETS: $targetList

   for target in $targetList
   do
      echo
      ping -c $PING_COUNT $target
      sleep $SLEEP_TIME
   done

done

