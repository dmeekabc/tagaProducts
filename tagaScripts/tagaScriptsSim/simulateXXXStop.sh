#!/bin/bash

#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

#echo $0 executing at `date`
#echo $MYIP : `basename $0` : executing at `date`
NAME=`basename $0`
#echo $MYIP : `basename $0` :  executing at `date`
echo "`$iboaUtilsDir/iboa_padded_echo.sh $MYIP:..$NAME 30` : executing at `date`"

################################################3
# MAIN 
################################################3

#XXX_DIR=~/code/xxx/python
XXX_DIR=$TAGA_DIR/code/xxx/python

if [ $MYIP == "192.168.43.69" ]; then
   echo `basename $0` $MYIP: stopping xxx daemon
   $XXX_DIR/xxx.py stop
elif [ $MYIP == "10.0.0.22" ]; then
   echo `basename $0` $MYIP: stopping xxx daemon
   $XXX_DIR/xxx.py stop
else
   echo `basename $0` $MYIP: stopping xxx daemon
   $XXX_DIR/xxx.py stop
fi

