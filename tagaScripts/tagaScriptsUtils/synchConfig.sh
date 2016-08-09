#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

MYLOCALLOGIN_ID=`$TAGA_UTILS_DIR/loginIdLookup.sh $MYIP | tail -n 1`
MYLOCALLOGIN_ID=`echo $MYLOCALLOGIN_ID`

# change to config dir
cd $TAGA_CONFIG_DIR >/dev/null

for target in $targetList
do

   TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
   source $TAGA_CONFIG_DIR/config

   # determine LOGIN ID for each target
   MYLOGIN_ID=`$TAGA_UTILS_DIR/loginIdLookup.sh $target | tail -n 1`
   # dlm temp , I have no clue why this is needed but it is...
   MYLOGIN_ID=`echo $MYLOGIN_ID` 

   TAGA_CONFIG_DIR=`echo $TAGA_CONFIG_DIR | sed -e s/$MYLOCALLOGIN_ID/MYLOGIN_ID/g`
   TAGA_CONFIG_DIR=`echo $TAGA_CONFIG_DIR | sed -e s/MYLOGIN_ID/$MYLOGIN_ID/g`

   # set the  synchIP.dat file flag to invoke the countWhile util
   echo 1 > /tmp/$target.synchIP.dat

   echo processing, synchronizing config $target
   #echo $target : synching config
   # start countoff in background
   $TAGA_UTILS_DIR/countWhile.sh /tmp/$target.synchIP.dat &

   #echo processing, synchronizing config $target

   # build the source file string
   SCP_SOURCE_STR="$SCP_SOURCE_STR config"
   SCP_SOURCE_STR="$SCP_SOURCE_STR config_admin"
   SCP_SOURCE_STR="$SCP_SOURCE_STR config_overrides" # config overrides ARE synchronized
   #SCP_SOURCE_STR="$SCP_SOURCE_STR config_extensions" # config extensions ARE NOT synchronized
   SCP_SOURCE_STR="$SCP_SOURCE_STR targetList.sh"
   SCP_SOURCE_STR="$SCP_SOURCE_STR hostList.txt"
   SCP_SOURCE_STR="$SCP_SOURCE_STR midsizeTargetList.txt"
   SCP_SOURCE_STR="$SCP_SOURCE_STR largeTargetList.txt"

   # do not use scp if target == MYIP and local mode flag set
   if cat $TAGA_LOCAL_MODE_FLAG_FILE 2>/dev/null | grep 1 >/dev/null ; then
      if [ $target == $MYIP ]; then
         # send the files to the destination
         #cp $SCP_SOURCE_STR $TAGA_CONFIG_DIR <$TAGA_CONFIG_DIR/passwd.txt
         cp $SCP_SOURCE_STR $TAGA_CONFIG_DIR # <$TAGA_CONFIG_DIR/passwd.txt
      else
         # send the files to the destination
         #scp $SCP_SOURCE_STR $MYLOGIN_ID@$target:$TAGA_CONFIG_DIR <$TAGA_CONFIG_DIR/passwd.txt
         scp $SCP_SOURCE_STR $MYLOGIN_ID@$target:$TAGA_CONFIG_DIR # <$TAGA_CONFIG_DIR/passwd.txt
      fi
   else
      # send the files to the destination
      #scp $SCP_SOURCE_STR $MYLOGIN_ID@$target:$TAGA_CONFIG_DIR <$TAGA_CONFIG_DIR/passwd.txt
      scp $SCP_SOURCE_STR $MYLOGIN_ID@$target:$TAGA_CONFIG_DIR # <$TAGA_CONFIG_DIR/passwd.txt
   fi

   # clear the synchIP.dat file flag to stop the countWhile util
   rm /tmp/$target.synchIP.dat

done

# change to orig dir
cd - >/dev/null




