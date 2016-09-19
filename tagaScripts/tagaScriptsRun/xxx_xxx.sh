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

#######################
# params example
# $1="Device1"
# $2="/tmp/device1.data"
# $3="/tmp/device1.out"
#######################

  # pad target name as necessary to have nice output
  IP_LEN=`echo $MYIP | awk '{print length($0)}'`

  if [ $IP_LEN -eq 17 ] ; then
    myip=$MYIP\ 
  elif [ $IP_LEN -eq 16 ] ; then
    myip=$MYIP\. 
  elif [ $IP_LEN -eq 15 ] ; then
    myip=$MYIP\.. 
  elif [ $IP_LEN -eq 14 ] ; then
    myip=$MYIP\... 
  elif [ $IP_LEN -eq 13 ] ; then
    myip=$MYIP\.... 
  elif [ $IP_LEN -eq 12 ] ; then
    myip=$MYIP\..... 
  elif [ $IP_LEN -eq 11 ] ; then
    myip=$MYIP\..... 
  elif [ $IP_LEN -eq 10 ] ; then
    myip=$MYIP\...... 
  else
    myip=$MYIP\....... 
  fi


if [ $1 == "Device1" ] ; then
  PAD=".."
elif [ $1 == "Device2" ] ; then
  PAD="....."
elif [ $1 == "Device3" ] ; then
  PAD=".........."
elif [ $1 == "Device4" ] ; then
  PAD=".............."
elif [ $1 == "Device5" ] ; then
  PAD=".................."
fi 


while true
do
   # output to terminal if enabled
   if [ $MAX_OUTPUT_ENABLED -eq 1 ]; then
      echo `date -Iseconds | cut -c1-19` $myip : $1:KnobSetting:$PAD: `cat $2 2>/dev/null` 
   fi
   # output to log file
   echo `date -Iseconds | cut -c1-19` $myip : $1:KnobSetting:$PAD: `cat $2 2>/dev/null` >> $3
   sleep 1
done
