#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

for target in $targetList
do
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
   ssh $target
done
echo

echo $0 returned to self...; echo
echo $0 complete!; echo
