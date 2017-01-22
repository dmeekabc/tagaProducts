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

SCRIPT_FILE=/tmp/yangcli-pro-script.tagaSetState 

echo; echo $0 : $MYIP :  executing at `date`; echo

if [ $# -ne 1 ]; then
   echo "$0: Error - this command requires a single parameter (state)"
   echo;echo Exiting with no Action;echo
   exit
else
   state=$1
fi

if [ $state == "blue" ] || [ $state == "green" ] ||
   [ $state == "red" ] || [ $state == "orange" ] ||
   [ $state == "yellow" ]; then
   echo "Input state : $state"
else
   echo "Invalid Input state ($state)"
   echo;echo Exiting with no Action;echo
   exit
fi

# provide the info to print into the confirmation request
InfoToPrint="If confirmed, the TAGA State will be updated to $state"

# issue confirmation prompt and check reponse
$tagaUtilsDir/confirm.sh $0 "$InfoToPrint"
response=$?; if [ $response -ne 1 ]; then exit; fi

# continue to execute the command
echo $0 Proceeding.... at `date`; echo

########################
# Build the Script File
########################
echo connect --server=yangapi-dev --user=pi --password=raspberry   >  $SCRIPT_FILE
echo set-$state-state                                              >> $SCRIPT_FILE
echo quit                                                          >> $SCRIPT_FILE

########################
# Run the Script File
########################
yangcli-pro --run-script  $SCRIPT_FILE
