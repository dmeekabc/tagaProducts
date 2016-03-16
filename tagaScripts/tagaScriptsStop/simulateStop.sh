#!/bin/bash

#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

################################################3
# MAIN STOP 
################################################3

# One Time / Single Operation Kill Invocations

# Kill xxx_xxx
PS_SEARCH_STR="xxx_xxx"
kill `ps -ef | grep $PS_SEARCH_STR | cut -c9-15` 2>/dev/null
# Kill iboa_xxx
PS_SEARCH_STR="iboa_xxx"
kill `ps -ef | grep $PS_SEARCH_STR | cut -c9-15` 2>/dev/null
# Kill iboa_sim1
PS_SEARCH_STR="iboa_sim1"
kill `ps -ef | grep $PS_SEARCH_STR | cut -c9-15` 2>/dev/null


