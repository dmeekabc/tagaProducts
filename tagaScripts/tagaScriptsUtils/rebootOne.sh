#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

# issue confirmation prompt
$tagaUtilsDir/confirm.sh $0 \
   "WARNING: This command will reboot the following: $FIXED_ONE_LIST"
# check the response
response=$?; if [ $response -ne 1 ]; then exit; fi

# reboot
for target in $FIXED_ONE_LIST
do
   echo
   echo processing $target
   if [ $target == $MYIP ]; then
      echo skipping self for now...
      continue
   fi

   echo rebooting $target .....
   ssh -l $MYLOGIN_ID $target sudo reboot <$TAGA_CONFIG_DIR/passwd.txt

done
echo

