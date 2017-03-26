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
TAGA_DIR=/home/pi/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

# These "date" files should not actually be created.
# If you see "date" files, there is a problem in the caller
# The caller should call with two params avoiding usage of these "date" files
INPUT_FILE=/tmp/aver-std-values-input.dat
OUTPUT_FILE=/tmp/aver-std.dat`date +%s`

let DEBUG=0
let DEBUG=1

if [ $# -eq 2 ] ; then
   echo Two params
   INPUT_FILE=$1
   OUTPUT_FILE=$2
   # dlm temp DEBUG
   #OUTPUT_FILE=/tmp/aver-std.dat`date +%s`
   #OUTPUT_FILE=/tmp/aver-std.dat

   if [ $DEBUG -eq 1 ]; then
      echo outputfile param is: $OUTUT_FILE > /tmp/`basename $0`.debug.out
      #OUTPUT_FILE=/tmp/tagaTrend.sh.aver-std.dat
   fi

else
   echo NOT Two params
   INPUT_FILE=/tmp/aver-std-values-input.dat
   OUTPUT_FILE=/tmp/aver-std.dat
fi

let DEBUG=0
let DEBUG=1

echo; echo $0 : $MYIP :  executing at `date`; echo

###########
# DO It
###########
awk '{for(i=1;i<=NF;i++) {sum[i] += $i; sumsq[i] += ($i)^2}} 
   END {for (i=1;i<=NF;i++) {
   printf "%f %f \n", sum[i]/NR, sqrt((sumsq[i]-sum[i]^2/NR)/NR)}
}' $INPUT_FILE >> $OUTPUT_FILE


###########
# PRINT It
###########
if [ $DEBUG -eq 1 ] ; then
   echo $OUTPUT_FILE contents start-------------:
   cat  $OUTPUT_FILE 
   echo $OUTPUT_FILE contents end---------------
fi 
