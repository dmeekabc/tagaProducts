#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

MYLOCALLOGIN_ID=`$TAGA_UTILS_DIR/loginIdLookup.sh $MYIP | tail -n 1`

# stop the simulations
for target in $targetList
do

   # determine LOGIN ID for each target
   MYLOGIN_ID=`$TAGA_UTILS_DIR/loginIdLookup.sh $target | tail -n 1`
   # dlm temp , I have no clue why this is needed but it is...
   MYLOGIN_ID=`echo $MYLOGIN_ID` 

   COMMAND_TO_RUN=$tagaScriptsStopDir/simulateStop.sh     
   COMMAND_TO_RUN=`echo $COMMAND_TO_RUN | sed -e s/$MYLOCALLOGIN_ID/MYLOGIN_ID/g`
   COMMAND_TO_RUN=`echo $COMMAND_TO_RUN | sed -e s/MYLOGIN_ID/$MYLOGIN_ID/g`

   if echo $BLACKLIST | grep $target >/dev/null ; then
      echo The $target is in the black list, skipping...
      continue
   else
      echo `basename $0` processing $target
     if [ $STOP_SIMULATION -eq 1 ] ; then
       #echo STOP simulation processing on $target
       #ssh -l $MYLOGIN_ID $target $tagaScriptsStopDir/simulateStop.sh     & 
       ssh -l $MYLOGIN_ID $target $COMMAND_TO_RUN  & 
     else
       echo NOT STOPING simulation processing on $target
     fi
   fi
done

# stop everything else
# note, this used to be the stopAll.sh script which is now OBE

for target in $targetList
do

   # determine LOGIN ID for each target
   MYLOGIN_ID=`$TAGA_UTILS_DIR/loginIdLookup.sh $target | tail -n 1`
   # dlm temp , I have no clue why this is needed but it is...
   MYLOGIN_ID=`echo $MYLOGIN_ID` 

   COMMAND_TO_RUN=$tagaScriptsStopDir/stop.sh     
   COMMAND_TO_RUN=`echo $COMMAND_TO_RUN | sed -e s/$MYLOCALLOGIN_ID/MYLOGIN_ID/g`
   COMMAND_TO_RUN=`echo $COMMAND_TO_RUN | sed -e s/MYLOGIN_ID/$MYLOGIN_ID/g`

   if echo $BLACKLIST | grep $target >/dev/null ; then
      echo The $target is in the black list, skipping...
      continue
   elif [ $target == $MYIP ]; then
      echo skipping self for now...
      continue
   fi

   echo processing, cleaning $target
   #ssh -l $MYLOGIN_ID $target $tagaScriptsStopDir/stop.sh $1 <$TAGA_CONFIG_DIR/passwd.txt
   ssh -l $MYLOGIN_ID $target $COMMAND_TO_RUN $1 <$TAGA_CONFIG_DIR/passwd.txt
done

# do myself last

# do not use scp if target == MYIP and local mode flag set
if cat $TAGA_LOCAL_MODE_FLAG_FILE 2>/dev/null | grep 1 >/dev/null ; then
   if [ $target == $MYIP ]; then
      echo processing, cleaning $MYIP
      $tagaScriptsStopDir/stop.sh $1 <$TAGA_CONFIG_DIR/passwd.txt
   else
      echo processing, cleaning $MYIP
      ssh -l $MYLOGIN_ID $MYIP $tagaScriptsStopDir/stop.sh $1 <$TAGA_CONFIG_DIR/passwd.txt
   fi
else
   echo processing, cleaning $MYIP
   ssh -l $MYLOGIN_ID $MYIP $tagaScriptsStopDir/stop.sh $1 <$TAGA_CONFIG_DIR/passwd.txt
fi


