#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

COMMAND_TO_WRAP=$tagaScriptsUtilsDir/resourceUsage.sh

for target in $targetList
do

   if echo $BLACKLIST | grep $target >/dev/null ; then
      echo The $target is in the black list, skipping...
      continue
   else
      echo ----------------------------
      echo Resource Usage: $target 
      echo ----------------------------
      #echo `basename $0` processing $target .......
   fi

  sleep 1 
  ssh -l $MYLOGIN_ID $target $COMMAND_TO_WRAP
  sleep 1 
done
