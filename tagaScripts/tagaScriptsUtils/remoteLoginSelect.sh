#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

for target in $targetList
do

   # determine LOGIN ID for each target
   MYLOGIN_ID=`$TAGA_UTILS_DIR/loginIdLookup.sh $target | tail -n 1`
   # dlm temp , I have no clue why this is needed but it is...
   MYLOGIN_ID=`echo $MYLOGIN_ID` 

   echo
   echo processing $target
   if [ $target == $MYIP ]; then
      echo skipping self... 
      continue
   fi

   # provide the info to print into the confirmation request
   InfoToPrint="Remotely Logging into $target - Proceed? "

   # issue confirmation prompt and check reponse
   $tagaUtilsDir/confirm.sh $0 "$InfoToPrint"
   response=$?; if [ $response -ne 1 ]; then echo Skpipping!; continue; fi

   echo Remotely logging into $target vis SSH ...
   ssh -l $MYLOGIN_ID $target
done
echo

echo $0 returned to self...; echo
echo $0 complete!; echo
