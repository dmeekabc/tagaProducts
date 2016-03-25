#!/bin/bash

#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

#echo $0 executing at `date`
#echo $MYIP : `basename $0` :  executing at `date`
NAME=`basename $0`
#echo $MYIP : `basename $0` :  executing at `date`
echo "`$iboaUtilsDir/iboa_padded_echo.sh $MYIP:..$NAME 30` : executing at `date`"

################################################3
# MAIN 
################################################3
PUBSUB_DIR=$TAGA_DIR/code/nanomsg_app/PubSub

if [ $MYIP == "192.168.43.69" ]; then
   #echo $MYIP : `basename $0` : simulate running testPubSubServer
   echo "`$iboaUtilsDir/iboa_padded_echo.sh $MYIP:..$NAME 30` : starting pubsub serverer at `date`"
   #$PUBSUB_DIR/testPubSubServer.sh 
elif [ $MYIP == "10.0.0.22" ]; then
   #echo $MYIP : `basename $0` : simulate running testPubSubServer
   echo "`$iboaUtilsDir/iboa_padded_echo.sh $MYIP:..$NAME 30` : starting pubsub serverer at `date`"
   #$PUBSUB_DIR/testPubSubServer.sh 
else
   #echo $MYIP : `basename $0` : simulate running testPubSubClient 
   echo "`$iboaUtilsDir/iboa_padded_echo.sh $MYIP:..$NAME 30` : starting pubsub serverer at `date`"
   #$PUBSUB_DIR/testPubSubClient.sh 
fi


