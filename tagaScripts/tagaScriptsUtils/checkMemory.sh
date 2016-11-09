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

# Set Threshold Constats/Values

let MINOR_THRESHOLD=500000
let MAJOR_THRESHOLD=400000
let ALARM_THRESHOLD=300000


#################################################
# Get the Value of Interest
#################################################

# Get the free memory 
let freeMemory=`vmstat | tail -n 1 | awk '{print $4}'`
#echo $freeMemory

#################################################
# DO IT, Check for Warning and Alarm Conditions
#################################################

if [ $freeMemory -lt $ALARM_THRESHOLD ]; then
   echo
   echo "`date`: ###### ###### ALARM!!: Free Memory ($freeMemory) is below ALARM_THRESHOLD ($ALARM_THRESHOLD) ###### ######"
   echo "`date`: ###### ###### ALARM!!: Free Memory ($freeMemory) is below ALARM_THRESHOLD ($ALARM_THRESHOLD) ###### ######"
   echo "`date`: ###### ###### ALARM!!: Free Memory ($freeMemory) is below ALARM_THRESHOLD ($ALARM_THRESHOLD) ###### ######"
   echo "`date`: ###### ###### ALARM!!: Free Memory ($freeMemory) is below ALARM_THRESHOLD ($ALARM_THRESHOLD) ###### ######" >> /tmp/tagaAlarm.log
   echo
   exit 1
elif [ $freeMemory -lt $MAJOR_THRESHOLD ]; then
   echo
   echo "`date`: ###### ###### WARNING: Free Memory ($freeMemory) is below MAJOR_THRESHOLD ($MAJOR_THRESHOLD) ###### ######"
   echo "`date`: ###### ###### WARNING: Free Memory ($freeMemory) is below MAJOR_THRESHOLD ($MAJOR_THRESHOLD) ###### ######"
   echo "`date`: ###### ###### WARNING: Free Memory ($freeMemory) is below MAJOR_THRESHOLD ($MAJOR_THRESHOLD) ###### ######" >> /tmp/tagaAlarm.log
   echo
   exit 1
elif [ $freeMemory -lt $MINOR_THRESHOLD ]; then
   echo
   echo "`date`: ###### ###### WARNING: Free Memory ($freeMemory) is below MINOR_THRESHOLD ($MINOR_THRESHOLD) ###### ######"
   echo "`date`: ###### ###### WARNING: Free Memory ($freeMemory) is below MINOR_THRESHOLD ($MINOR_THRESHOLD) ###### ######" >> /tmp/tagaWarn.log
   echo
   exit 1
else
   echo
   echo `date`: INFO: Free Memory \($freeMemory\) is above Minor_Threshold \($MINOR_THRESHOLD\) \(Normal\)
   echo `date`: INFO: Free Memory \($freeMemory\) is above Minor_Threshold \($MINOR_THRESHOLD\) \(Normal\) >> /tmp/tagaInfo.log
   exit 0
fi
