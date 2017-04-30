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

PING_COUNT=2
SLEEP_TIME=1
SLEEP_TIME=0

echo; echo $0 : $MYIP :  executing at `date`

while true
do

   let successCount=0
   let failureCount=0

   failureList=""

   # get the config in case it has changed
   source $TAGA_CONFIG_DIR/config

   for target in $targetList
   do
      echo

      if /bin/hostname | grep raspberrypi >/dev/null ; then
         sudo ping -c $PING_COUNT $target
      else
         ping -c $PING_COUNT $target
      fi

      if [ $? -eq 0 ]; then
         let successCount=$successCount+1
      else
         let failureCount=$failureCount+1
         failureList="$failureList $target"
      fi
      sleep $SLEEP_TIME
   done

    echo
    echo  Ping Success Count: $successCount
    echo  Ping Failure Count: $failureCount
    echo

    #if [ $failureList == "" ] ; then
    #  echo  Failed List: $failureList >/dev/null
    #else
    #  echo  Failed List: $failureList
    #  echo
    #fi

    # dlm temp, not sure why the above won't run without error so do this instead?
    for item in $failureList
    do
       echo  Failed List: $failureList
       echo
       break
    done

   # If we have a flag parameter and have looped once, then exit now!!
   # If we have a flag parameter and have looped once, then exit now!!
   if [ $# -gt 0 ] ; then
      # any param is a flag indicating to run one time only
       sleep 5
       echo
       echo  Command Complete, pausing for 5 secs...
       echo
       sleep 5
      exit
   fi


done
