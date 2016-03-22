#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

# change to config dir
cd $TAGA_CONFIG_DIR

for target in $targetList
do
   echo processing, synchronizing config $target

   # build the source file string
   SCP_SOURCE_STR="$SCP_SOURCE_STR config"
   SCP_SOURCE_STR="$SCP_SOURCE_STR config_overrides"
   SCP_SOURCE_STR="$SCP_SOURCE_STR targetList.sh"
   SCP_SOURCE_STR="$SCP_SOURCE_STR hostList.txt"

   # do not use scp if target == MYIP and local mode flag set
   if cat $TAGA_LOCAL_MODE_FLAG_FILE 2>/dev/null | grep 1 ; then
      if [ $target == $MYIP ]; then
         # send the files to the destination
         cp $SCP_SOURCE_STR $TAGA_CONFIG_DIR <$TAGA_CONFIG_DIR/passwd.txt
      else
         # send the files to the destination
         scp $SCP_SOURCE_STR $MYLOGIN_ID@$target:$TAGA_CONFIG_DIR <$TAGA_CONFIG_DIR/passwd.txt
      fi
   else
      # send the files to the destination
      scp $SCP_SOURCE_STR $MYLOGIN_ID@$target:$TAGA_CONFIG_DIR <$TAGA_CONFIG_DIR/passwd.txt
   fi

done

# change to orig dir
cd -




