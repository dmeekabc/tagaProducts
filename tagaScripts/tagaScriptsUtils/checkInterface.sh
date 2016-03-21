#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config


let retCodeSum=0

echo PINGING TARGETS: $targetList

for target in $targetList
do
   echo
   ping -c 1 $target
   let retCode=$?
   echo retCode: $retCode
   if [ $retCode -eq 2 ] ; then
      echo Unreachable Network Detected, Not much we can do...
      # exit the routine, not much we can do
      exit
   else
      let retCodeSum=$retCodeSum+$retCode
      echo retCodeSum: $retCodeSum
   fi
   if [ $retCodeSum -ge 1 ] ; then
      # we have all the info we need... go ahead and break out
      break
   fi
done

if [ $retCodeSum -ge 1 ] ; then
   # more than one bad return, this implies our interface may be bad
   echo Interface is in suspect state - resetting! 
   echo Interface is in suspect state - setting interface down!
   sudo ifconfig $INTERFACE  down < $TAGA_CONFIG_DIR/passwd.txt
   echo Retcode:$?
   sleep 5
   echo Interface is in suspect state - setting interface up!
   sudo ifconfig $INTERFACE  up < $TAGA_CONFIG_DIR/passwd.txt
   echo Retcode:$?
fi

