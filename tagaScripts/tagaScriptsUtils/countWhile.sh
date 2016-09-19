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

FILE_TO_CHECK=$1

COUNTWHILE_DAT_FILE=/tmp/countWhile.dat

let i=0
while true
do
  let i=$i+1

  if [ -f $FILE_TO_CHECK ]; then
#    let MODVAL=$i%2
    let MODVAL=$i%1
    if [ $MODVAL -eq 0 ]; then
        # sleep before the first print
        sleep 1
         # print once per second while file to check exists
        # print to the terminal only if in EXPERT display mode
        # conditional output to standard out
        if [ $TAGA_DISPLAY_EXPERT -eq 1 ] ; then printf "%d" $i; printf "%c" " " ; fi
        # always print to the log
        # non-conditional output to outfile
        printf "%d" $i >> $COUNTWHILE_DAT_FILE ; printf "%c" " " >> $COUNTWHILE_DAT_FILE 
      #  sleep 1
    fi
  else
    # this is our exit point
    # conditional output to standard out
    # close output to standard out
    # file to check does not exist (no longer exists)... we are done here...
    if [ $TAGA_DISPLAY_EXPERT -eq 1 ] ; then printf "\n"; echo; date; fi
    # non-conditional output to outfile
    # close output to output file
    printf "\n"  >> $COUNTWHILE_DAT_FILE 
    echo         >> $COUNTWHILE_DAT_FILE
    date         >> $COUNTWHILE_DAT_FILE
    # this is our exit point
    exit
  fi
done

