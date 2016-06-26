#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

for target in $MASTER
do

   # determine LOGIN ID for each target
   MYLOGIN_ID=`$TAGA_UTILS_DIR/loginIdLookup.sh $target | tail -n 1`
   # dlm temp , I have no clue why this is needed but it is...
   MYLOGIN_ID=`echo $MYLOGIN_ID` 

   if [ $target == $MYIP ]; then
     echo skipping self \($target\)
     continue
   fi

   echo processing, synchronizing $target
   sleep 1

   # build the source file string
   SCP_SOURCE_STR="*"    

   sudo mkdir -p $LOG_DIR
   sudo chmod 777 $LOG_DIR
   scp -r $MYLOGIN_ID@$target:$LOG_DIR/$SCP_SOURCE_STR $LOG_DIR <$TAGA_CONFIG_DIR/passwd.txt

done

