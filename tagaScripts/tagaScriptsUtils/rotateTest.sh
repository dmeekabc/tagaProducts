#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

echo; echo $0 : $MYIP :  executing at `date`; echo

let i=1
while true
do
   echo "TEST_LABEL=\"Config$i\"" >>  $TAGA_CONFIG_DIR/config
   let i=$i+1
   #if [ $i -gt 8 ] ; then
   if [ $i -gt 6 ] ; then
      let i=1
   fi
   sleep 10
   #sleep 1800
done


