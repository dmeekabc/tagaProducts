#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

MYDIR=`pwd`

echo 
echo $targetList

for target in $targetList
do

   if [ $MYIP == $target ]; then
      echo skipping self...
   else
      echo processing, synchronizing $target
      sleep 1
      ssh -l $MYLOGIN_ID $target date
      ssh -l $MYLOGIN_ID $target hostname
      # build the source file string
      SCP_SOURCE_STR="code"
      # send the files to the destination
      ssh -l $MYLOGIN_ID $target mkdir -p $MYDIR
      scp -r $SCP_SOURCE_STR $MYLOGIN_ID@$target:$MYDIR \
              <$TAGA_CONFIG_DIR/passwd.txt
   fi

done

