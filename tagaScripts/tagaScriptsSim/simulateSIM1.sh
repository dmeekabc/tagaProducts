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

SIM1_DIR=$TAGA_DIR/tagaSamples/sim1/python

# cleanup old processes, resources, sockets and such
OLDPROCFILE3="/home/$MYLOGIN_ID/python/python.pid"
rm $OLDPROCFILE3 2>/dev/null

if [ $MYIP == $DAEMON1_IP ]; then
   echo $MYIP : `basename $0` : starting sim1 daemon1
   $SIM1_DIR/sim1.py start
elif [ $MYIP == $DAEMON2_IP ]; then
   echo $MYIP : `basename $0` : starting sim1 daemon2
   $SIM1_DIR/sim1.py start
else
   echo $MYIP : `basename $0` : starting sim1 daemonXXX
   $SIM1_DIR/sim1.py start
fi


