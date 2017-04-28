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

caller=$1
printInfo=$2

#####################################################3
# issuePrompt function
#####################################################3
function issuePrompt {
   echo
   echo Please Confirm to Proceed.
   echo
   echo Confirm? \(y/n\) \?
   echo

   autoConfirm=`/opt/tagaxxx/scripts/utils/getAutoConfirm.sh | cut -d: -f 2`

   if [ $autoConfirm -eq 1 ] ; then 
      echo Auto-confirmed
      return 1 # confirmed
   elif [ -f /tmp/tagaxxx_confirm.txt ] ; then 
      echo Auto-confirmed
      return 1 # confirmed
   else
      read input
      if [ $input == "y" ]; then
        return 1 # confirmed
      else
        return 2 # not confirmed
      fi
   fi
}

#####################################################3
# Main
#####################################################3

# print the info
echo
echo $printInfo

# issue the prompt
issuePrompt

# check the response
let response=$?
if [ $response -eq 1 ]; then
  echo; echo Confirmed, $caller continuing....; echo
else
  echo; echo Not Confirmed, $caller exiting or returning with no action...; echo
fi

# return the response to the caller
exit $response

