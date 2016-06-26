#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

# exit now if XXX is off
if [ $XXX_ON -eq 0 ]; then
  echo `basename $0` - XXX simulation is OFF, exiting with no action on $MYIP
  exit
fi

for target in $targetList
do

   # determine LOGIN ID for each target
   MYLOGIN_ID=`$TAGA_UTILS_DIR/loginIdLookup.sh $target | tail -n 1`
   # dlm temp , I have no clue why this is needed but it is...
   MYLOGIN_ID=`echo $MYLOGIN_ID` 

   if echo $BLACKLIST | grep $target ; then
      echo The $target is in the black list, skipping...
      continue
   else
      echo `basename $0` processing $target .......
   fi

   ssh -l $MYLOGIN_ID $target $tagaScriptsStopDir/stop_xxx.sh  <$TAGA_CONFIG_DIR/passwd.txt &

done



