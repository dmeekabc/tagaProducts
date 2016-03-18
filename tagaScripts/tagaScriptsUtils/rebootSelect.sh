#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

echo
echo WARNING: This command will reboot selected nodes in the network including zero or more of the following: `echo $targetList`
echo
echo NOTE: You will have the opportunity to individually confirm or deny the reboot of each node.

# issue confirmation prompt
$iboaUtilsDir/confirm.sh

let response=$?
if [ $response -eq 1 ]; then
  echo; echo Rebooting All....; echo
else
  echo; echo Reboot All Command Not Confirmed, Exiting without action...; echo
  exit
fi

for target in $targetList
do
   echo
   echo processing $target
   if [ $target == $MYIP ]; then
      echo skipping self for now...
      continue
   fi

   # provide the info to print into the confirmation request
   InfoToPrint="Preparing to reboot $target - Proceed? "

   # issue confirmation prompt and check reponse
   $tagaUtilsDir/confirm.sh $0 "$InfoToPrint"
   response=$?; if [ $response -ne 1 ]; then echo Skpipping!; continue; fi

   echo rebooting $target .....
   ssh -l $MYLOGIN_ID $target sudo reboot <$TAGA_CONFIG_DIR/passwd.txt
done
echo

# provide the info to print into the confirmation request
InfoToPrint="Preparing to reboot $MYIP - Proceed? "

# issue confirmation prompt and check reponse
$tagaUtilsDir/confirm.sh $0 "$InfoToPrint"
response=$?; if [ $response -ne 1 ]; then echo Skpipping!; echo; exit; fi

echo rebooting self now...
ssh -l $MYLOGIN_ID $MYIP sudo reboot <$TAGA_CONFIG_DIR/passwd.txt
