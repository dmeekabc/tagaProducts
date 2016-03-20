#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

# stop the simulations
for target in $targetList
do
   if [ $STOP_SIMULATION -eq 1 ] ; then
     echo STOP simulation processing on $target
     ssh -l $MYLOGIN_ID $target $tagaScriptsStopDir/simulateStop.sh     & 
   else
     echo NOT STOPING simulation processing on $target
   fi
done

# stop everything else
# note, this used to be the stopAll.sh script which is now OBE

for target in $targetList
do
   if [ $target == $MYIP ]; then
      echo skipping self for now...
      continue
   fi
   echo processing, cleaning $target
   ssh -l $MYLOGIN_ID $target $tagaScriptsStopDir/stop.sh  $1 <$TAGA_CONFIG_DIR/passwd.txt
done

# do myself last
echo processing, cleaning $MYIP
ssh -l $MYLOGIN_ID $MYIP $tagaScriptsStopDir/stop.sh  $1 <$TAGA_CONFIG_DIR/passwd.txt

