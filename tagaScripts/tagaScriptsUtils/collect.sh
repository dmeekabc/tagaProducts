#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

outputDir=$1

for target in $targetList
do
   echo
   echo processing, collecting files from $target start:`date | cut -c12-20`

   # if we are in local mode and target == MYIP , do not use ssh or scp
   if cat $TAGA_LOCAL_MODE_FLAG_FILE 2>/dev/null | grep 1 >/dev/null ; then
      if [ $target == $MYIP ]; then
        cp /tmp/$TEST_DESCRIPTION* $outputDir
        rm /tmp/$TEST_DESCRIPTION* 2>/dev/null 
      else
        scp $MYLOGIN_ID@$target:/tmp/$TEST_DESCRIPTION* $outputDir
        ssh -l $MYLOGIN_ID $target rm /tmp/$TEST_DESCRIPTION* 2>/dev/null 
      fi

   # normal mode
   else
      scp $MYLOGIN_ID@$target:/tmp/$TEST_DESCRIPTION* $outputDir
      ssh -l $MYLOGIN_ID $target rm /tmp/$TEST_DESCRIPTION* 2>/dev/null 
   fi

   echo processing, collecting files from $target  stop :`date | cut -c12-20`

done

echo
echo `basename $0` : Total File Count: `ls $outputDir | wc -l` Total Line Count: `cat $outputDir/* | wc -l`
echo

