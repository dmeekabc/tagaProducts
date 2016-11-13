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

targetList=$MYIP

##########################
# Verify Input
##########################

if [ $# -eq 1 ] ; then
   newTlmServiceStatus=$1
   if [ $? -eq 0 ] ; then
      if [ $newTlmServiceStatus == "enabled" ] ; then
         echo
         echo Info: $0 : Input parameter \(new tlm service status\) \($newTlmServiceStatus\) is valid.
         echo
      elif [ $newTlmServiceStatus == "disabled" ] ; then
         echo
         echo Info: $0 : Input parameter \(new tlm service status\) \($newTlmServiceStatus\) is valid.
         echo
      else
         echo
         echo Info: $0 : Input parameter \(new tlm service status\) \($newTlmServiceStatus\) not valid.
         echo Info: $0 Exiting with no action...
         echo
         exit
      fi
   else
      echo
      echo Info: $0 : Input parameter \(new tlm service status\) \($1\) not valid.
      echo Info: $0 Exiting with no action...
      echo
      exit
   fi
else
   echo
   echo Info: $0 requires a single input parameter \(new tlm service status\).
   echo Info: $0 Exiting with no action...
   echo
   exit
fi

echo; echo NETCONF Protocol in Use.
echo; echo Target List : $targetList
echo; echo Notice: If confirmed, the tlm service status will be changed to : $newTlmServiceStatus. 

#####################################################3
# issuePrompt function
#####################################################3
function issuePrompt {
echo
echo Please Confirm to Proceed.
echo
echo Confirm? \(y/n\) 
echo

read input

if [ $input == "y" ] 2>/dev/null; then
  echo Confirmed, continuing...
else
  echo Not Confirmed, exiting...
  exit
fi
}


##############
# MAIN
##############

# Issue the prompt
issuePrompt

CHANGE_TLM_SERVICE_STATUS_SCRIPTS_DIR=$HOME/scripts/taga/tagaScripts/tagaScriptsLogMgt
CHANGE_TLM_SERVICE_STATUS_TEMPLATE_FILE=$CHANGE_TLM_SERVICE_STATUS_SCRIPTS_DIR/yangcli-pro.script.changeTlmServiceStatus.n
CHANGE_TLM_SERVICE_STATUS_TEMP_FILE=/tmp/`basename $0`.txt.temp
CHANGE_TLM_SERVICE_STATUS_TEMP2_FILE=/tmp/`basename $0`.txt.temp2
CHANGE_TLM_SERVICE_STATUS_EXECUTION_SCRIPT=/tmp/`basename $0`.yangcli-pro.execution.script


# for each target, run the yangcli-pro client commands (script file)
for target in $targetList
do
   # prep the NETCONF Change Preset Command File
   sed -e s/TARGET/$target/g $CHANGE_TLM_SERVICE_STATUS_TEMPLATE_FILE        > $CHANGE_TLM_SERVICE_STATUS_TEMP_FILE   # create temp from template
   sed -e s/NEW_TLM_SERVIICE_STATUS/$newTlmServiceStatus/g $CHANGE_TLM_SERVICE_STATUS_TEMP_FILE > $CHANGE_TLM_SERVICE_STATUS_TEMP2_FILE  # toggle temp/temp2

   # give it a meaningful name
   cp $CHANGE_TLM_SERVICE_STATUS_TEMP2_FILE $CHANGE_TLM_SERVICE_STATUS_EXECUTION_SCRIPT  # finalize

   # Execute it!
   /usr/bin/yangcli-pro --run-script $CHANGE_TLM_SERVICE_STATUS_EXECUTION_SCRIPT
   
done

