#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

for target in $targetList
do
   echo XXX processing on $target

   # exit now if XXX if off
   if [ $XXX_ON -eq 0 ]; then
      break
   fi

   ssh -l $MYLOGIN_ID $target $tagaScriptsRunDir/device1.sh  <$TAGA_CONFIG_DIR/passwd.txt &
   ssh -l $MYLOGIN_ID $target $tagaScriptsRunDir/device2.sh  <$TAGA_CONFIG_DIR/passwd.txt &
   ssh -l $MYLOGIN_ID $target $tagaScriptsRunDir/device3.sh  <$TAGA_CONFIG_DIR/passwd.txt &
   ssh -l $MYLOGIN_ID $target $tagaScriptsRunDir/device4.sh  <$TAGA_CONFIG_DIR/passwd.txt &
   ssh -l $MYLOGIN_ID $target $tagaScriptsRunDir/device5.sh  <$TAGA_CONFIG_DIR/passwd.txt &

done



