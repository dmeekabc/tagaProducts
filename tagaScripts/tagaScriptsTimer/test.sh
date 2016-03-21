#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config


   $TAGA_UTILS_DIR/rebootOneB.sh $target & # < $TAGA_CONFIG_DIR/confirm.txt
   echo;echo $0 Suspending to let $target recover;echo
   $IBOA_UTILS_DIR/iboaDelay.sh 60 5

