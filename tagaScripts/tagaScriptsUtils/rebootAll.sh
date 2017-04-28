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

#dlmtemp changed 3 jan 2017 due to some strange error
targetList=$targetListBottomUp
targetList=$TARGET_LIST_BOTTOM_UP

#SKIP_LIST="22.209.44.90 22.209.44.74"

echo
echo WARNING: This command will reboot all nodes in the network including the following: $targetList

# issue confirmation prompt
#$iboaUtilsDir/confirm.sh
$tagaUtilsDir/confirm.sh


let response=$?
if [ $response -eq 1 ]; then
  echo; echo Rebooting All....; echo
else
  echo; echo Reboot All Command Not Confirmed, Exiting without action...; echo
  exit
fi

#dlm temp
#exit


for iter in 1 # 2 3 4 5
do
for target in $targetList
do
   echo
   echo processing $target
   if [ $target == $MYIP ]; then
      echo skipping self for now...
      continue
   elif echo $SKIP_LIST | grep $target >/dev/null ; then
      echo skipping other for now...
      continue
   fi
   echo rebooting $target .....
   ssh -l $MYLOGIN_ID $target sudo reboot <$TAGA_CONFIG_DIR/passwd.txt #&
done
echo
sleep 5
done

#for target in $targetList
#do
#   echo
#   echo processing $target
#   if [ $target == $MYIP ]; then
#      echo skipping self for now...
#      continue
#   fi
#   echo rebooting $target .....
#   ssh -l $MYLOGIN_ID $target sudo reboot <$TAGA_CONFIG_DIR/passwd.txt #&
#done
#echo



echo rebooting self now...
ssh -l $MYLOGIN_ID $MYIP sudo reboot <$TAGA_CONFIG_DIR/passwd.txt

