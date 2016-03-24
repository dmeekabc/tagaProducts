#!/bin/bash

#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

#echo $0 executing at `date`
echo $MYIP : `basename $0` : executing at `date`

################################################3
# MAIN 
################################################3

XXX_DIR=$TAGA_DIR/tagaSamples/xxx/python

# cleanup old processes, resources, sockets and such
OLDPROCFILE3="/home/$MYLOGIN_ID/python/python.pid"
rm $OLDPROCFILE3 2>/dev/null

if [ $MYIP == "192.168.43.69" ]; then
   echo $MYIP : `basename $0` : starting xxx daemon
   $XXX_DIR/xxx.py start
elif [ $MYIP == "10.0.0.22" ]; then
   echo $MYIP : `basename $0` : starting xxx daemon
   $XXX_DIR/xxx.py start
else
   echo $MYIP : `basename $0` : starting xxx daemon
   $XXX_DIR/xxx.py start
fi

