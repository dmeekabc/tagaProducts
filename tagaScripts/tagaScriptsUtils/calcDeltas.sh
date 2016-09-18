####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################
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

# vars
DELTA_FILE=/tmp/iboa/log/delta.out
PCAP_DATA_FILE=/tmp/iboa/log/ppc.out
TMP_FILE=/tmp/iboa/log/tmp.txt
TMP2_FILE=/tmp/iboa/log/tmp2.txt

# init
rm $DELTA_FILE ; touch $DELTA_FILE 
cp $PCAP_DATA_FILE $TMP_FILE 

# get line count
let lines=`cat $TMP_FILE | wc -l`

let i=0
while [ $lines -gt 1 ] 
do

   input=`head -n 1 $TMP_FILE`
   echo $input > input.txt
   read input1 input2 < input.txt
#   echo input1: $input1 
#   echo input2: $input2 

   let delta=$input1-$input2
#   echo $delta
   echo $delta >> $DELTA_FILE 

   let i=$i+1

   let MOD=$i%100

   let lines=`cat $TMP_FILE | wc -l`

   if [ $MOD -eq 0 ] ; then
      echo $i lines processed : $lines lines remain
   fi

   cat $TMP_FILE | sed 1d > $TMP2_FILE
   mv $TMP2_FILE $TMP_FILE

done


echo; echo Deltas are in $DELTA_FILE; echo

