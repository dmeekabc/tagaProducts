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

let DELAY=$1

TAGADELAY_DAT_FILE=/tmp/tagaDelay.dat

#echo
date

while [ $DELAY -ge 0 ]; 
do

   # if we have a modulus param, only print on the modulus
   if [ $# -eq 2 ]; then 
      let MODULUS=$2
      let MODULUS_VAL=$DELAY%$MODULUS
      if [ $MODULUS_VAL -eq 0 ]; then
        # conditional output to standard out
        if [ $TAGA_DISPLAY_EXPERT -eq 1 ] ; then printf "%d" $DELAY; printf "%c" " " ; fi
        # non-conditional output to outfile
        printf "%d" $DELAY >> $TAGADELAY_DAT_FILE; printf "%c" " " >> $TAGADELAY_DAT_FILE
      fi
   else
     # conditional output to standard out
     if [ $TAGA_DISPLAY_EXPERT -eq 1 ] ; then printf "%d" $DELAY; printf "%c" " " ; fi
     # non-conditional output to outfile
     printf "%d" $DELAY >> $TAGADELAY_DAT_FILE ; printf "%c" " " >> $TAGADELAY_DAT_FILE
   fi

   let DELAY=$DELAY-1

   # don't sleep if we have hit 0
   if [ $DELAY -ge 0 ]; then
     sleep 1
   fi

done

# we are done here...

# close output to standard out
printf "\n"  

#echo
date

# close output to out file
printf "\n" >> $TAGADELAY_DAT_FILE 
echo        >> $TAGADELAY_DAT_FILE 
date        >> $TAGADELAY_DAT_FILE 


