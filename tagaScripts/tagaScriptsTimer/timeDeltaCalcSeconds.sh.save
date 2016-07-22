#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config


if [ -f /tmp/markSecs1.dat ] ; then
   date +%s > /tmp/markSecs2.dat
   let START=`cat /tmp/markSecs1.dat`
   let END=`cat /tmp/markSecs2.dat`
   let DELTA=$END-$START
   echo $DELTA seconds
   rm /tmp/markSecs1.dat
   rm /tmp/markSecs2.dat
else
   date +%s > /tmp/markSecs1.dat
fi

