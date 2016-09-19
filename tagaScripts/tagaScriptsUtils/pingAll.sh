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

# method to determine gateway name
GW_DETERMINATINO_METHOD="runtime"
GW_DETERMINATINO_METHOD="config"

# allow target list override if any param is provided
if [ $# -eq 1 ]; then
   let USE_ALT_LIST=1
else
   let USE_ALT_LIST=0
fi

PING_COUNT=2
SLEEP_TIME=1
SLEEP_TIME=0

echo; echo $0 : $MYIP :  executing at `date`

#echo; echo $0: Determining GATEWAY....; echo
#MYGATEWAY=`route | grep default | cut -c16-30`
#echo GATEWAY: $MYGATEWAY

while true
do
   # get the config in case it has changed
   source $TAGA_CONFIG_DIR/config

   # get the gateway in case it has changed
   echo; date; echo Determining GATEWAY....

   if [ $GW_DETERMINATINO_METHOD == "runtime" ] ; then
      # get gateway via runtime check
      MYGATEWAY=`route | grep default | cut -c16-30`
   else
      # get gateway via config
      MYGATEWAY=$NETADDRPART.1
   fi
   echo GATEWAY: $MYGATEWAY

   if [ $USE_ALT_LIST -eq 1 ]; then
      targetList=$FIXED_ALT_LIST
   fi

   # ping the gateway
   echo; echo PINGING GATEWAY: $MYGATEWAY; echo
   ping -c $PING_COUNT $MYGATEWAY
   sleep $SLEEP_TIME

   # ping the targets
   echo; date
   echo PINGING TARGETS: $targetList

   for target in $targetList
   do
      echo
      sudo ping -c $PING_COUNT $target
      sleep $SLEEP_TIME
   done

done

