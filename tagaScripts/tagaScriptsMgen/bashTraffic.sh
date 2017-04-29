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

# dlm temp, udp only for now
mgen_proto=udp

#####################################
# Delay
#####################################
$tagaMgenDir/trafficDelay.sh $1 $2

# dlm temp , this above is no working, hard code it for now
sleep 10 

function sendit {
   dd if=/tmp/tagaSize.dat bs=$MSGLEN count=1 > /dev/$mgen_proto/$target/$DESTPORT
}

#####################################
#####################################
# MAIN
#####################################
#####################################

####################################
# Make Dummy File as Source
####################################
$tagaUtilsDir/makeFile.sh $MSGLEN

####################################
# Do the Traffic
####################################

# use the activated flag to stagger starts and ensure only one effective loop out of the two below
let activated=0

# init port-related vars
let i=0


###############################
# First Half of UCAST Loop
###############################
for target in $targetList
do
  
  let i=$i+1

  if [ $target == $MYIP ]; then
    #echo target is MYIP , skipping self... 
    let activated=1
    continue
  fi

  # use the activated flag to stagger starts and ensure only one effective loop out of the two loops
  # if not activated, continue to top
  if [ $activated -eq 0 ]; then
    continue
  fi

  let DESTPORT=$PORTBASE+$i

   echo TAGA: $MYIP : Sending $MSGCOUNT packets of $MSGLEN bytes to $target port $DESTPORT
   let j=$MSGCOUNT
   while [ $j -gt 0 ] 
   do

      #dd if=/tmp/tagaSize.dat bs=$MSGLEN count=1 > /dev/$mgen_proto/$target/$DESTPORT

      if [ $TAGA_DISPLAY_SETTING -ge $TAGA_DISPLAY_ENUM_VAL_4_VERBOSE ]; then
        echo TAGA: $MYIP : Sending $MSGLEN bytes to $target port $DESTPORT
      elif [ $TAGA_DISPLAY_SETTING -le $TAGA_DISPLAY_ENUM_VAL_1_SILENT ]; then
         echo TAGA: $MYIP : Sending $MSGLEN bytes to $target port $DESTPORT >/dev/null
      else
        echo TAGA: $MYIP : Sending $MSGLEN bytes to $target port $DESTPORT >/dev/null
      fi

      sendit >/dev/null 2>/dev/null

      sleep 1
      let j=$j-1
   done

done

###############################
# Second Half of UCAST Loop
###############################
# reinit port-related vars
let i=0
# actiivated flag is okay

for target in $targetList
do
  
  let i=$i+1

  if [ $target == $MYIP ]; then
    #echo target is MYIP , skipping self... 
    let activated=0
    continue
  fi

  # use the activated flag to stagger starts and ensure only one effective loop out of the two loops
  # if not activated, continue to top
  if [ $activated -eq 0 ]; then
    continue
  fi

  let DESTPORT=$PORTBASE+$i

   echo TAGA: $MYIP : Sending $MSGCOUNT packets of $MSGLEN bytes to $target port $DESTPORT
   let j=$MSGCOUNT
   while [ $j -gt 0 ] 
   do

      #dd if=/tmp/tagaSize.dat bs=$MSGLEN count=1 > /dev/$mgen_proto/$target/$DESTPORT

      if [ $TAGA_DISPLAY_SETTING -ge $TAGA_DISPLAY_ENUM_VAL_4_VERBOSE ]; then
        echo TAGA: $MYIP : Sending $MSGLEN bytes to $target port $DESTPORT
      elif [ $TAGA_DISPLAY_SETTING -le $TAGA_DISPLAY_ENUM_VAL_1_SILENT ]; then
         echo TAGA: $MYIP : Sending $MSGLEN bytes to $target port $DESTPORT >/dev/null
      else
        echo TAGA: $MYIP : Sending $MSGLEN bytes to $target port $DESTPORT >/dev/null
      fi

      sendit >/dev/null 2>/dev/null

      sleep 1
      let j=$j-1
   done

done


