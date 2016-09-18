#!/bin/bash
#######################################################################
#
# Copyright (c) IBOA Corp 2016
#
# All Rights Reserved
#                                                                     
# Redistribution and use in source and binary forms, with or without  
# modification, are permitted provided that the following conditions 
# are met:                                                             
# 1. Redistributions of source code must retain the above copyright    
#    notice, this list of conditions and the following disclaimer.     
# 2. Redistributions in binary form must reproduce the above           
#    copyright notice, this list of conditions and the following       
#    disclaimer in the documentation and/or other materials provided   
#    with the distribution.                                            
#                                                                      
# THIS SOFTWARE IS PROVIDED BY THE AUTHORS ``AS IS'' AND ANY EXPRESS   
# OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED    
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE   
# ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHORS OR CONTRIBUTORS BE     
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR  
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT    
# OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR   
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF           
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT            
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE    
# USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH     
# DAMAGE.                                                              
#
#######################################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

COMMON_PARAMS="--user=$MYLOGIN_ID --password=$MYPASSWD --batch-mode"

DEVICE1_COMMAND="device1:change-knob --knobSetting"
DEVICE2_COMMAND="device2:change-knob --knobSetting"
DEVICE3_COMMAND="device3:change-knob --knobSetting"

# grab some randomness from the date command
if date | cut -c18-19 | grep 8  ; then
    DEVICE1_COMMAND="$DEVICE1_COMMAND=3"
    DEVICE2_COMMAND="$DEVICE2_COMMAND=3"
    DEVICE3_COMMAND="$DEVICE3_COMMAND=8"

elif date | cut -c18-19 | grep 9  ; then
    DEVICE1_COMMAND="$DEVICE1_COMMAND=2"
    DEVICE2_COMMAND="$DEVICE2_COMMAND=2"
    DEVICE3_COMMAND="$DEVICE3_COMMAND=5"
 
elif date | cut -c18-19 | grep 1  ; then
    DEVICE1_COMMAND="$DEVICE1_COMMAND=5"
    DEVICE2_COMMAND="$DEVICE2_COMMAND=5"
    DEVICE3_COMMAND="$DEVICE3_COMMAND=2"

elif date | cut -c18-19 | grep 4 ; then
    DEVICE1_COMMAND="$DEVICE1_COMMAND=4"
    DEVICE2_COMMAND="$DEVICE2_COMMAND=4"
    DEVICE3_COMMAND="$DEVICE3_COMMAND=2"

elif date | cut -c18-19 | grep 2 ; then
    DEVICE1_COMMAND="$DEVICE1_COMMAND=8"
    DEVICE2_COMMAND="$DEVICE2_COMMAND=8"
    DEVICE3_COMMAND="$DEVICE3_COMMAND=3"

elif date | cut -c18-19 | grep 7 ; then
    DEVICE1_COMMAND="$DEVICE1_COMMAND=7"
    DEVICE2_COMMAND="$DEVICE2_COMMAND=7"
    DEVICE3_COMMAND="$DEVICE3_COMMAND=3"

elif date | cut -c18-19 | grep 3 ; then
    DEVICE1_COMMAND="$DEVICE1_COMMAND=1"
    DEVICE2_COMMAND="$DEVICE2_COMMAND=1"
    DEVICE3_COMMAND="$DEVICE3_COMMAND=6"

elif date | cut -c18-19 | grep 6 ; then
    DEVICE1_COMMAND="$DEVICE1_COMMAND=6"
    DEVICE2_COMMAND="$DEVICE2_COMMAND=6"
    DEVICE3_COMMAND="$DEVICE3_COMMAND=7"

else
    DEVICE1_COMMAND="$DEVICE1_COMMAND=7"
    DEVICE2_COMMAND="$DEVICE2_COMMAND=7"
    DEVICE3_COMMAND="$DEVICE3_COMMAND=1"
fi


for target in $targetList
do

  echo `date` ChangeKnobSetting:

  echo $0 $target `date` Cmd1: RetVal: TBD
  TEE_FILE=/tmp/TestXXX_$target.out
  echo $COMMAND :`date` : hostname:`hostname` target:$target -------------------------- | tee $TEE_FILE
  $COMMAND --server=$target $COMMON_PARAMS --run-command="list commands" 
  RETVAL=$?
  echo $0 $target `date` Cmd1: RetVal: $RETVAL
  $COMMAND --server=$target $COMMON_PARAMS --run-command="list commands" >> $TEE_FILE 
  RETVAL=$?
  echo $0 $target `date` Cmd2: RetVal: $RETVAL
  $COMMAND --server=$target $COMMON_PARAMS --run-command="$DEVICE2_COMMAND" 
  RETVAL=$?
  echo $0 $target `date` Cmd3: RetVal: $RETVAL
  $COMMAND --server=$target $COMMON_PARAMS --run-command="$DEVICE2_COMMAND" >> $TEE_FILE
  RETVAL=$?
  echo $0 $target `date` Cmd4: RetVal: $RETVAL
  $COMMAND --server=$target $COMMON_PARAMS --run-command="$DEVICE3_COMMAND" 
  RETVAL=$?
  echo $0 $target `date` Cmd5: RetVal: $RETVAL
  $COMMAND --server=$target $COMMON_PARAMS --run-command="$DEVICE3_COMMAND" >> $TEE_FILE
  RETVAL=$?
  echo $0 $target `date` Cmd6: RetVal: $RETVAL

  echo "$0 $target `date` Done ($target)"

done
