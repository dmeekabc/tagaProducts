#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

for target in $targetList
do
   if [ $target == $MYIP ]; then
      echo skipping self for now...
      continue
   fi
   echo processing, cleaning $target
   ssh -l $MYLOGIN_ID $target $tagaScriptsStopDir/stop.sh  <$TAGA_CONFIG_DIR/passwd.txt
done

# do myself last
echo processing, cleaning $MYIP
ssh -l $MYLOGIN_ID $MYIP $tagaScriptsStopDir/stop.sh  <$TAGA_CONFIG_DIR/passwd.txt

