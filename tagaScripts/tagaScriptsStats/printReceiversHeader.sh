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

# get the input
iter=$2
startTime=$3
startDTG=$4

##################################################################
# Print Header Rows
##################################################################

# print header row
echo;echo
echo >> $TAGA_RUN_DIR/counts.txt

#echo `date` Iteration:$iter StartDTG: $startTime $startDTG $TESTTYPE
#echo `date` Iteration:$iter StartDTG: $startTime $startDTG $TESTTYPE >> $TAGA_RUN_DIR/counts.txt

if [ $NARROW_DISPLAY -eq 1 ]; then
  row="$1 TABLE       ------------------ RECEIVERS LIST --------------------"
elif [ $WIDE_DISPLAY -eq 1 ]; then
  row="$1 TABLE       -----------------------------------------------------------------------------------------------------------------  RECEIVERS LIST -----------------------------------------------------------------------------------------------------------------------"
else
  row="$1 TABLE       -------------------------------------  RECEIVERS LIST --------------------------------------------"
fi


#row="$1 TABLE   --------------------------------------  RECEIVERS LIST --------------------------------------------"
#if [ $NARROW_DISPLAY -eq 1 ]; then
#  row="$1 TABLE   ------------------ RECEIVERS LIST --------------------"
#fi

echo "$row"
echo "$row" >> $TAGA_RUN_DIR/counts.txt

if [ $NARROW_DISPLAY -eq 1 ]; then
  row="    1    2    3    4    5    6    7    8    9    10   Tot"
elif [ $WIDE_DISPLAY -eq 1 ]; then
  row="    1    2    3    4    5    6    7    8    9   10   11   12   13   14   15   16   17   18   19   20   21   22   23   24   25   26   27   28   29   30   31   32   33   34   35   36   37   38   39   40   41   42   43   44   45   46   47   48   49   50"
else
  row="    1    2    3    4    5    6    7    8    9   10   11   12   13   14   15   16   17   18   19   20"
fi

#row="   1    2    3    4    5    6    7    8    9   10   11   12   13   14   15   16   17   18   19   20"
#if [ $NARROW_DISPLAY -eq 1 ]; then
#  row="1    2    3    4    5    6    7    8    9    10   Tot"
#fi

echo "SENDERS LIST      $row"
echo "SENDERS LIST      $row" >> $TAGA_RUN_DIR/counts.txt

if [ $NARROW_DISPLAY -eq 1 ]; then
  row="------------          ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----"
elif [ $WIDE_DISPLAY -eq 1 ]; then
  row="-------------         ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----"
else
  row="-------------         ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----"
fi

#  row="-------------     ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----"
#if [ $NARROW_DISPLAY -eq 1 ]; then
#  row="------------      ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----"
#fi

echo "$row"
echo "$row" >> $TAGA_RUN_DIR/counts.txt


