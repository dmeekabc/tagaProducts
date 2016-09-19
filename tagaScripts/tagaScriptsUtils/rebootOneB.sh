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

if [ $# -eq 1 ] ; then

rebootTarget=$1

# issue confirmation prompt
#$tagaUtilsDir/confirm.sh $0 \
$tagaUtilsDir/confirmbasic.sh $0 < $tagaUtilsDir/confirm.txt 
# check the response
response=$?; if [ $response -ne 1 ]; then exit; fi

# reboot
for target in $rebootTarget
do
   echo
   echo processing $target
   if [ $target == $MYIP ]; then
      echo skipping self ...
      continue
   fi
   echo rebooting $target .....
   ssh -l $MYLOGIN_ID $target sudo reboot <$TAGA_CONFIG_DIR/passwd.txt

done
echo

else

# issue confirmation prompt
$tagaUtilsDir/confirmbasic.sh $0 < $tagaUtilsDir/confirm.txt 
#$tagaUtilsDir/confirm.sh $0 \
#   "WARNING: This command will reboot the following: $FIXED_ONE_LIST"
# check the response
response=$?; if [ $response -ne 1 ]; then exit; fi

# reboot
for target in $FIXED_ONE_LIST
do
   echo
   echo processing $target
   if [ $target == $MYIP ]; then
      echo skipping self...
      continue
   fi

   echo rebooting $target .....
   ssh -l $MYLOGIN_ID $target sudo reboot <$TAGA_CONFIG_DIR/passwd.txt

done
echo

fi
