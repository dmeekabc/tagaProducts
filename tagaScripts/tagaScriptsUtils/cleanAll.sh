#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

for target in $targetList
do
   if cat $TAGA_LOCAL_MODE_FLAG_FILE 2>/dev/null | grep 1 ; then
      # do not use ssh if target == MYIP and local mode flag set
      if [ $target == $MYIP ]; then
        echo processing, cleaning $target
        $tagaScriptsUtilsDir/clean.sh
      else
        echo processing, cleaning $target
        ssh -l $MYLOGIN_ID $target $tagaScriptsUtilsDir/clean.sh
      fi
   else
        echo processing, cleaning $target
        ssh -l $MYLOGIN_ID $target $tagaScriptsUtilsDir/clean.sh
   fi
done

