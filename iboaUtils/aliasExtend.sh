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

ALIAS_FILE=$iboaUtilsDir/aliasExamples.txt
#ALIAS_FILE=$iboaUtilsDir/aliasList.txt

# validate input
if [ $# -eq 1 ]; then
   ALIAS_FILE=$1
   echo; echo $0 executing with the following param input... $1; echo
   echo; echo $0 : $MYIP :  executing at `date`; echo
else
   echo; echo $0 executing with no param input...; echo
fi


##########################################################
# note, prior to running this script, # run the following: 
#
#    alias > $TAGA_DIR/aliasList.txt
##########################################################

# if confirmation, required, get the confirmation

#if [ $CONFIRM_REQD -eq 1 ] ; then
if [ true ] ; then
   # ensure proper setup
   echo Please confirm that you would like to extend your aliases by sourcing the follwing file: 
   echo "$ALIAS_FILE"
   # issue confirmation prompt
   $iboaUtilsDir/confirm.sh
   # check the response
   let response=$?
   if [ $response -eq 1 ]; then
     echo; echo Confirmed, $0 continuing....; echo
   else
     echo; echo Not Confirmed, $0 exiting with no action...; echo
     exit
   fi
fi

echo sourcing $ALIAS_FILE;echo
source $ALIAS_FILE
echo Done!;echo

