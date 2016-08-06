#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

# get the input which provides multi-task support
#   ... that is as long as the calling folks pass a param as expected!


if [ $# -eq 0 ] ; then
  echo WARNING: Calling this $0 script without a parameter is acceptable but it is not thread safe.
fi


if [ -f /tmp/markSecs1.$1.dat ] ; then
   date +%s > /tmp/markSecs2.$1.dat
   let START=`cat /tmp/markSecs1.$1.dat`
   let END=`cat /tmp/markSecs2.$1.dat`
   let DELTA=$END-$START
   echo $DELTA seconds
   rm /tmp/markSecs1.$1.dat
   rm /tmp/markSecs2.$1.dat
else
   date +%s > /tmp/markSecs1.$1.dat
fi

