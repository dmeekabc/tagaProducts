#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

# basic sanity check, to ensure password updated etc
./basicSanityCheck.sh
if [ $? -eq 255 ]; then
  echo Basic Sanith Check Failed - see warning above - $0 Exiting...
  echo
  exit 255
fi


for target in $targetList
do
   echo
   echo `date` : probing $target
   echo $target: `ssh -l $MYLOGIN_ID $target hostname`
   echo $target: `ssh -l $MYLOGIN_ID $target date`
   echo $target: `ssh -l $MYLOGIN_ID $target uptime`
   echo $target: `ssh -l $MYLOGIN_ID $target /sbin/ifconfig | grep HWaddr`
   echo $target: `ssh -l $MYLOGIN_ID $target /sbin/ifconfig | grep inet6`
done
echo


