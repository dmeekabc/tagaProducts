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

TAGA_DIR=/home/pi/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

ARCHIVE=/home/pi/scripts/taga/archive

echo Retrieving Max Log Duration from Database...
currentSeconds=`date +%s`
maxLogDurationString=`/home/pi/scripts/taga/tagaScripts/tagaScriptsUtils/yangUtils/getTlmMaxLogDuration.sh`
maxDurationMinutes=`echo $maxLogDurationString | cut -d" " -f 2`

echo
echo currentSeconds:$currentSeconds maxMinutes:$maxDurationMinutes
let maxDurationSeconds=$maxDurationMinutes*60
echo currentSeconds:$currentSeconds maxSeconds:$maxDurationSeconds
let cutoff=$currentSeconds-$maxDurationSeconds
echo cutoff:$cutoff
echo
for file in $ARCHIVE/output*
do
   if [ $file ] ; then
      if echo $file | cut -d_ -f 3 >/dev/null ; then
      let secondsString=`echo $file | cut -d_ -f 3`
      if [ $secondsString ]; then
      if [ $secondsString -le $cutoff ]; then
         echo $file exceeds max log duration, moving to /tmp to be deleted on reboot
         mv $file /tmp
      else
         echo $file within max log duration, no action 
      fi
      else
         echo no secondString, no action 
      fi
      else
         echo cannot parse file name, no action
      fi
   fi
done



