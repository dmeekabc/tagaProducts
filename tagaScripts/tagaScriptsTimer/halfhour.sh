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

# NOTE: This command is known to be resource intenstive, do not use in production

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

echo; echo $0 : $MYIP :  executing at `date`; echo

# provide the info to print into the confirmation request
#InfoToPrint="$0 Put Your Info To Print Here. $0 "
# issue confirmation prompt and check reponse
#$tagaUtilsDir/confirm.sh $0 "$InfoToPrint"
#response=$?; if [ $response -ne 1 ]; then exit; fi
# continue to execute the command
#echo $0 Proceeding.... at `date`; echo

FILE1=/tmp/cancelTimeBasedTrigger.txt
FILE2=/tmp/cancelTimeBasedOperation.txt
rm $FILE1  2>/dev/null
rm $FILE2  2>/dev/null

while true
do 
  source $TAGA_CONFIG_DIR/config

  #  backdoor mechanism to cancel the time-based trigger (proceed immediately) or time-based operation (cancel)
  if [ -f $FILE1 ]; then
     rm $FILE1 
     exit 1
  elif [ -f $FILE2 ]; then
     rm $FILE2
     exit 2
  fi 

  echo 1: `date`

   # first, ensure we hit the end of an appropriate time frame
   if date | cut -d: -f 2 | cut -c1-2 | grep -e ^29 -e ^59 ; then
   while true
   do
  echo 2: `date`
   # next, ensure we hit the end of a minute 
   if date | cut -d: -f 3 | cut -c1-2 | grep ^59 ; then
   # next, ensure we hit the end of a second 
   while true
   do 
   if echo `date +%N` | grep ^9 >/dev/null ; then
   # next, look for the beginning of the next second...
   if echo `date +%N` | grep ^0 ; then
      #date +%N
      date -Ins
      echo
      exit 0
   fi
   fi
   done
   fi
   done
   fi
done

# Note, we should never get here but just in case...

exit 0
