#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

echo 
echo $targetList

echo $0 not currently supported - exiting
exit

# change to config dir
cd $TAGA_CONFIG_DIR

for target in $targetList
do
   echo processing, synchronizing $target
   sleep 1

   # build the source file string
   SCP_SOURCE_STR="*.sh"
   SCP_SOURCE_STR="$SCP_SOURCE_STR *.txt"  
   SCP_SOURCE_STR="$SCP_SOURCE_STR host*"  
   SCP_SOURCE_STR="$SCP_SOURCE_STR config"
   SCP_SOURCE_STR="$SCP_SOURCE_STR config_overrides"
   SCP_SOURCE_STR="$SCP_SOURCE_STR *.template"

   # send the files to the destination
   scp $SCP_SOURCE_STR $MYLOGIN_ID@$target:$TAGA_CONFIG_DIR <$TAGA_CONFIG_DIR/passwd.txt

   # synch bashrc.iboa files
   #scp ~/.bashrc.iboa* $MYLOGIN_ID@$target:~/ <$TAGA_CONFIG_DIR/passwd.txt

   # clean up old OBE scripts (run once per file in all environs)
   # but check the flag first
   # flip the flag once I have been run in all environs
   if [ $EXTRA_FILE_CLEANUP_ENABLED -eq 0 ]; then
      continue
   fi

done

# change to orig dir
cd -
