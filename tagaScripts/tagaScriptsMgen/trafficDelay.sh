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

LOG_FILE=/tmp/`basename $0`.log
echo $0 : $MYIP :  executing at `date` > $LOG_FILE

#####################################################################
# SLEEP / DELAY HANDLING
#####################################################################
#sleep $SERVER_INIT_DELAY
let CURRENT_EPOCH=`date +%s`

# determine the time to start sending traffic (set wait time accorrdingly)
if [ $# -ge 2 ] ; then
   # we have a start time parameter, get it and calc wait time...
   let TRAFFIC_START_EPOCH=$2
   let WAITTIME=$TRAFFIC_START_EPOCH-$CURRENT_EPOCH
else
   # if we have no start time param, start immediately (set wait time to 0)
   let WAITTIME=0
fi

# round to nearest 5
# note, this rounding impacts the "traffic start synch"
# note that this round time becomes a: 
#    "closest ensured traffic start time synch"
# note, 
let ROUND_TIME=1
let ROUND_TIME=5
let WAITTIME=$WAITTIME/$ROUND_TIME
let WAITTIME=$WAITTIME*$ROUND_TIME
let WAITTIME=$WAITTIME+$ROUND_TIME

# if wait time exceeds, max allowed, set it to the max wait time allowed
MAX_WAIT_TIME=40
MAX_WAIT_TIME=80
MAX_WAIT_TIME=120
MAX_WAIT_TIME=10
MAX_WAIT_TIME=20
if [ $WAITTIME -gt $MAX_WAIT_TIME ]; then
  let WAITTIME=MAX_WAIT_TIME
fi

# ensure non-negative wait time
if [ $WAITTIME -lt 0 ]; then
   echo
   echo Warning: $0: negatie WAITTIME: $WAITTIME
   echo Warning: $0: negatie WAITTIME: $WAITTIME
   echo Warning: Bad SUDO, SSH, bad time synch, bad config, etc can cause delays , this condition.
   echo Warning: Bad SUDO, SSH, bad time synch, bad config, etc can cause delays , this condition.
   echo Warning: Consider increasing MGEN_SERVER_INIT_DELAY
   echo Warning: Consider increasing MGEN_SERVER_INIT_DELAY
   echo
   # something is wrong, wait max amount of time
   let WAITTIME=MAX_WAIT_TIME
fi

if [ $WAITTIME -gt 0 ]; then

   #echo TAGA: $MYIP : Waiting $WAITTIME seconds to Start MGEN Sender...

   if [ $TAGA_DISPLAY_SETTING -ge $TAGA_DISPLAY_ENUM_VAL_4_VERBOSE ]; then
#     echo  waiting:$WAITTIME
      sleep $WAITTIME
     #$TAGA_UTILS_DIR/tagaDelay.sh $WAITTIME
#     echo done waiting:$WAITTIME
   elif [ $TAGA_DISPLAY_DEBUG -eq 1 ]; then
#     echo  waiting:$WAITTIME
      sleep $WAITTIME
     #$TAGA_UTILS_DIR/tagaDelay.sh $WAITTIME
#     echo done waiting:$WAITTIME
   else
     #sleep $WAITTIME
#     echo  waiting:$WAITTIME
      sleep $WAITTIME
     #$TAGA_UTILS_DIR/tagaDelay.sh $WAITTIME
#     echo Done waiting:$WAITTIME seconds
     #echo TAGA: Starting mgen Receiver...
#     echo TAGA: Starting mgen Sender...
   fi

   #echo TAGA: $MYIP : DONE Waiting $WAITTIME seconds to Start MGEN Sender...
   #echo TAGA: $MYIP : Starting MGEN Sender...
   echo TAGA: $MYIP : Wait Complete: $WAITTIME sec waited: Starting Traffic Now...

fi

#####################################################################
# SLEEP / DELAY HANDLING
#####################################################################

