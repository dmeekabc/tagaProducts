#!/bin/bash

#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

echo $MYIP : `basename $0` : executing at `date`

################################################3
# MAIN 
################################################3

SIM1_DIR=~/code/sim1/python
SIM1_DIR=$TAGA_DIR/code/sim1/python

if [ $MYIP == "192.168.43.69" ]; then
   echo `basename $0` $MYIP: stopping sim1.py daemon
   $SIM1_DIR/sim1.py stop
elif [ $MYIP == "10.0.0.22" ]; then
   echo `basename $0` $MYIP: stopping sim1.py daemon
   $SIM1_DIR/sim1.py stop
else
   echo `basename $0` $MYIP: stopping sim1.py daemon
   $SIM1_DIR/sim1.py stop
fi

