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
   echo STOP XXX simulation on $target
   ssh -l $MYLOGIN_ID $target $tagaScriptsStopDir/stop_xxx.sh  <$TAGA_CONFIG_DIR/passwd.txt &
done



