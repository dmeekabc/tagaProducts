#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
source $TAGA_DIR/config

COMMAND_TO_WRAP=$TAGA_DIR/resourceUsage.sh

for target in $targetList
do
  #echo $0 processing $target .......
  echo ----------------------------------
  echo Node Resource Usage: $target 
  echo ----------------------------------
  sleep 1 
  ssh -l $MYLOGIN_ID $target $COMMAND_TO_WRAP
  sleep 1 
done
