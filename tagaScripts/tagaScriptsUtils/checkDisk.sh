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
let MINOR_THRESHOLD=80
let MAJOR_THRESHOLD=90
let ALARM_THRESHOLD=95
let MINOR_THRESHOLD=88
let MAJOR_THRESHOLD=90
let ALARM_THRESHOLD=92
let MINOR_THRESHOLD=94
let MAJOR_THRESHOLD=96
let ALARM_THRESHOLD=98

# Get the disk usage
diskPercentUsageString=`df . | grep dev`

let i=0
let percentUsage=0
let stringLength=`echo $diskPercentUsageString | wc -c`

# find the % character within the diskPercentUsageString and
# use the preceding two characters as our percentUsage value.
while [ $i -lt $stringLength ]
do
   let i=$i+1
   charToExamine=`echo $diskPercentUsageString | cut -c$i `
   #echo charToExamine:$charToExamine
   if [ $charToExamine == '%' ] 2>/dev/null; then
      #echo found:$i
      let startindex=$i-2
      let stopindex=$i-1
      let percentUsage=`echo $diskPercentUsageString | cut -c$startindex-$stopindex`
      #echo percentUsage:$percentUsage
      break
   fi
done

# oddly enough, here, a percentUsage == 0 actually indicates 100% usage
if [ $percentUsage -eq 0 ]; then
   echo
   echo "###### ###### ALARM!!: Disk Usage (100%) exceeds ALARM_THRESHOLD ($ALARM_THRESHOLD%) ###### ######"
   echo "###### ###### ALARM!!: Disk Usage (100%) exceeds ALARM_THRESHOLD ($ALARM_THRESHOLD%) ###### ######"
   echo "###### ###### ALARM!!: Disk Usage (100%) exceeds ALARM_THRESHOLD ($ALARM_THRESHOLD%) ###### ######"
   echo
   exit 1
elif [ $percentUsage -gt $ALARM_THRESHOLD ]; then
   echo
   echo "###### ###### ALARM!!: Disk Usage ($percentUsage%) exceeds ALARM_THRESHOLD ($ALARM_THRESHOLD%) ###### ######"
   echo "###### ###### ALARM!!: Disk Usage ($percentUsage%) exceeds ALARM_THRESHOLD ($ALARM_THRESHOLD%) ###### ######"
   echo "###### ###### ALARM!!: Disk Usage ($percentUsage%) exceeds ALARM_THRESHOLD ($ALARM_THRESHOLD%) ###### ######"
   echo
   exit 1
elif [ $percentUsage -gt $MAJOR_THRESHOLD ]; then
   echo
   echo "###### ###### WARNING: Disk Usage ($percentUsage%) exceeds MAJOR_THRESHOLD ($MAJOR_THRESHOLD%) ###### ######"
   echo "###### ###### WARNING: Disk Usage ($percentUsage%) exceeds MAJOR_THRESHOLD ($MAJOR_THRESHOLD%) ###### ######"
   echo "###### ###### WARNING: Disk Usage ($percentUsage%) exceeds MAJOR_THRESHOLD ($MAJOR_THRESHOLD%) ###### ######"
   echo
   exit 1
elif [ $percentUsage -gt $MINOR_THRESHOLD ]; then
   echo
   echo "###### ###### WARNING: Disk Usage ($percentUsage%) exceeds MINOR_THRESHOLD ($MINOR_THRESHOLD%) ###### ######"
   echo
   exit 1
else
   echo
   echo INFO: Disk Usage \($percentUsage%\) is below Minor_Threshold \($MINOR_THRESHOLD%\) \(Normal\)
   exit 0
fi
