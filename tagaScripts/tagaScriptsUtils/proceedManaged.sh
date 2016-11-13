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

MAX_WAIT_LOOPS=1000000
MAX_WAIT_LOOPS=10

#####################################################3
# issuePrompt function
#####################################################3
function issuePrompt {

cd $HOME/scripts/taga/tagaScripts/tagaScriptsUtils

let counter=0
retCode=1

while [ $retCode -ne 0 ] 
do
   echo `date` : Press \<Enter\> Key to Proceed...
   ./managedExecute.sh -t 1 ./readInput.sh 2> /dev/null
   retCode=$?
#   echo $retCode
   if [ $retCode -eq 0 ] ; then
      echo done waiting >dev/null
      break
   else
      echo still waiting >/dev/null
      let counter=$counter+1
      if [ $counter -ge $MAX_WAIT_LOOPS ] ; then
         echo; echo Max Wait Time Exceeded, Proceeding ...; echo
         break
      fi
   fi
done

}

#####################################################3
# Main
#####################################################3

# issue the prompt
issuePrompt


