#!/bin/bash
#######################################################################
#
# Copyright (c) IBOA Corp 2017
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

echo; echo $0 : $MYIP :  executing at `date`; echo

#########
# PREP
#########

FILE_TO_SPLIT=/home/pi/snmp_install/walkit4.out
SPLIT_FILE=/tmp/tagaSplitFile.out
rm $SPLIT_FILE* 2>/dev/null

# Get target count
let count=0
for target in $targetList; do let count=$count+1; done ; echo count:$count

let lineCount=`cat $FILE_TO_SPLIT | wc -l`
let lineCountPerTarget=$lineCount/count

echo
echo lineCount:$lineCount
echo lineCountPerTarget:$lineCountPerTarget
echo

sleep 5


#################################################
# DO IT
# Okay prep work is done, now split the file
#################################################

# DO IT

let count=0
for target in $targetList
do
   let count=$count+1

   # Get the pertinent part of the top of the file
   let tempLines=$lineCountPerTarget*$count

   echo tempLines:$tempLines
   sleep 5

   cat $FILE_TO_SPLIT | head -n $tempLines | tail -n $lineCountPerTarget > $SPLIT_FILE.$target

   cat $SPLIT_FILE.$target >> $SPLIT_FILE

done
