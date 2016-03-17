#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

echo $0 : $MYIP :  executing at `date`

REMOTE_NODE=$FIXED_ONE_LIST
REMOTE_NODE_ITFC=$FIXED_ONE_LIST_ITFC
echo $0 : $MYIP remote to $REMOTE_NODE and $REMOTE_NODE_ITFC:  executing at `date`

# issue confirmation prompt
$iboaUtilsDir/confirm.sh

let response=$?
if [ $response -eq 1 ]; then
  echo; echo Rebooting $FIXED_ONE_LIST ....; echo
else
  echo; echo Reboot $FIXED_ONE_LIST Command Not Confirmed, Exiting without action...; echo
  exit
fi


./remoteWiresharkCapture.sh 1
sleep 5
./remoteWiresharkCapture.sh 2 &
sleep 5
./remoteWiresharkCapture.sh 3

