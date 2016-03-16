#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

for target in $targetList
do
   echo processing, cleaning $target
   ssh -l $MYLOGIN_ID $target $tagaScriptsUtilsDir/clean.sh
done

