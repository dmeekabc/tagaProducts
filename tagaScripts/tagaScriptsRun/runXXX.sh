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

# exit now if XXX if off
if [ $XXX_ON -eq 0 ]; then
  echo $0 - XXX simulation is OFF, exiting with no action on $MYIP
  exit
fi

for target in $targetList
do
   # determine LOGIN ID for each target
   MYLOGIN_ID=`$TAGA_UTILS_DIR/loginIdLookup.sh $target | tail -n 1`
   # dlm temp , I have no clue why this is needed but it is...
   MYLOGIN_ID=`echo $MYLOGIN_ID` 

   echo XXX processing on $target
  
   if [ $DEVICE1_ON -eq 1 ]; then
     ssh -l $MYLOGIN_ID $target $tagaScriptsRunDir/xxx_xxx.sh Device1 /tmp/device1.data /tmp/device1.out <$TAGA_CONFIG_DIR/passwd.txt &
   fi
   if [ $DEVICE2_ON -eq 1 ]; then
     ssh -l $MYLOGIN_ID $target $tagaScriptsRunDir/xxx_xxx.sh Device2 /tmp/device1.data /tmp/device2.out <$TAGA_CONFIG_DIR/passwd.txt &
   fi
   if [ $DEVICE3_ON -eq 1 ]; then
     ssh -l $MYLOGIN_ID $target $tagaScriptsRunDir/xxx_xxx.sh Device3 /tmp/device1.data /tmp/device3.out <$TAGA_CONFIG_DIR/passwd.txt &
   fi
   if [ $DEVICE4_ON -eq 1 ]; then
     ssh -l $MYLOGIN_ID $target $tagaScriptsRunDir/xxx_xxx.sh Device4 /tmp/device1.data /tmp/device4.out <$TAGA_CONFIG_DIR/passwd.txt &
   fi
   if [ $DEVICE5_ON -eq 1 ]; then
     ssh -l $MYLOGIN_ID $target $tagaScriptsRunDir/xxx_xxx.sh Device5 /tmp/device1.data /tmp/device5.out <$TAGA_CONFIG_DIR/passwd.txt &
   fi

done



