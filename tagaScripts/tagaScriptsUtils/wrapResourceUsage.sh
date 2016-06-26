#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config


MYLOCALLOGIN_ID=`$TAGA_UTILS_DIR/loginIdLookup.sh $MYIP | tail -n 1`
MYDIR=`pwd`
MYDIR=`echo $MYDIR | sed -e s/$MYLOCALLOGIN_ID/MYLOGIN_ID/g`

COMMAND_TO_WRAP=$tagaScriptsUtilsDir/resourceUsage.sh
COMMAND_TO_WRAP=`echo $COMMAND_TO_WRAP | sed -e s/$MYLOCALLOGIN_ID/MYLOGIN_ID/g`


for target in $targetList
do
   # determine LOGIN ID for each target
   MYLOGIN_ID=`$TAGA_UTILS_DIR/loginIdLookup.sh $target | tail -n 1`
   # dlm temp , I have no clue why this is needed but it is...
   MYLOGIN_ID=`echo $MYLOGIN_ID` 


   COMMAND_TO_WRAP=$tagaScriptsUtilsDir/resourceUsage.sh
   COMMAND_TO_WRAP=`echo $COMMAND_TO_WRAP | sed -e s/$MYLOCALLOGIN_ID/MYLOGIN_ID/g`
   COMMAND_TO_WRAP=`echo $COMMAND_TO_WRAP | sed -e s/MYLOGIN_ID/$MYLOGIN_ID/g`


   if echo $BLACKLIST | grep $target >/dev/null ; then
      echo The $target is in the black list, skipping...
      continue
   else
      #echo `basename $0` processing $target .......
      echo
      echo --------------------------
      echo Resource Usage: $target 
      echo --------------------------
   fi

  sleep 1 
  ssh -l $MYLOGIN_ID $target $COMMAND_TO_WRAP
  sleep 1 
done
