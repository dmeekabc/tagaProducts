#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

echo
echo WARNING: This command will reboot the following: $FIXED_ONE_LIST
echo
echo Are you sure? \(y/n\) ?
echo

# issue confirmation prompt
$iboaUtilsDir/confirm.sh

let response=$?
if [ $response -eq 1 ]; then
  echo; echo Rebooting $FIXED_ONE_LIST ....; echo
else
  echo; echo Reboot $FIXED_ONE_LIST Command Not Confirmed, Exiting without action...; echo
  exit
fi

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
   ssh -l $MYLOGIN_ID $target sudo reboot <$TAGA_CONFIG_DIR/taga/passwd.txt

done
echo

