#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

#echo myip: $MYIP

# get MYLOGIN_ID from the config or the loginIdMap file if the file exists
MYLOGIN_ID=`$TAGA_UTILS_DIR/loginIdLookup.sh $MYIP | tail -n 1`

#echo login: $MYLOGIN_ID

if echo $MYLOGIN_ID | grep GoesHere >/dev/null ; then
   echo
   echo NOTICE: Config file missing required information.
   echo
   echo NOTICE: Please update the Config File: $TAGA_CONFIG_DIR/config or the Config Overrides
   echo         File: $TAGA_CONFIG_DIR/config_overrides with the information shown below.
   echo
   echo "     e.g. [ MYLOGIN_ID: $MYLOGIN_ID ] "
   echo
   echo Note: MYIP: $MYIP
   echo Note: MYLOGIN_ID: $MYLOGIN_ID
   echo
   exit 255
#elif echo $MYPASSWD | grep GoesHere >/dev/null ; then
#   echo
#   echo WARNING: It appears you have not updated the config file with your configuration information
#   echo e.g. [ MYPASSWD: $MYPASSWD ]
#   echo
#   exit 255
else
   echo Basic Check Passed >/dev/null
fi

exit 0

