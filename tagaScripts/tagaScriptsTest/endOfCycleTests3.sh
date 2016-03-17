#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

if [ $END_OF_CYCLE_TESTS3_ENABLED == 1 ]; then
  echo `basename $0` End of Cycle Tests3 Enabled - proceeding...
else
  echo `basename $0` End of Cycle Tests3 Disabled - Exiting
  exit
fi

COMMON_PARAMS="--user=$MYLOGIN_ID --password=$MYPASSWD --batch-mode"


for target in $targetList
do
  TEE_FILE=/tmp/endOfCycleTest3_$target.out
  TEE_FILE=/tmp/endOfCycleTest3_$target.out
  echo $COMMAND :`date` : hostname:`hostname` target:$target -------------------------- | tee $TEE_FILE
  $COMMAND --server=$target $COMMON_PARAMS --run-command="list commands" >> $TEE_FILE 
  $COMMAND --server=$target $COMMON_PARAMS --run-command="get-config --source=running" >> $TEE_FILE 
done


