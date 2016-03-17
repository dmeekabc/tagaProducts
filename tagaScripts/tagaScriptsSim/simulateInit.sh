#!/bin/bash

#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

echo `basename $0` $MYIP executing at `date`

#####################################
# SIMULATE INIT FUNCTION
#####################################

# cleanup old processes, resources, sockets and such
rm $OLDSOCKPROCFILE1 2>/dev/null 
rm $OLDSOCKPROCFILE2 2>/dev/null

