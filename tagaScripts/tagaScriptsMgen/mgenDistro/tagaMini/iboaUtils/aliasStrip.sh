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
TAGA_DIR=/tmp/tagaMini
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

CONFIRM_REQD=1

# list of things to strip
STRIP_LIST=`cat $iboaUtilsDir/stripList.txt`
ALIAS_FILE=$iboaUtilsDir/aliasList.txt
ALIAS_STRIPPED_FILE=$iboaUtilsDir/aliasListStripped.txt

echo; echo $0 : $MYIP :  executing at `date`; echo

echo;echo; echo StipList... `ls $iboaUtilsDir/stripList.txt 2>/dev/null`

# validate input
echo
echo Keywords :: [ $STRIP_LIST ] 
echo
echo NOTE: The keywords above will be stripped from $ALIAS_FILE 
echo and a new resultant file written to $ALIAS_STRIPPED_FILE
$iboaUtilsDir/confirm.sh
let response=$?
if [ $response -eq 1 ]; then
  echo; echo Confirmed, $0 continuing....; echo
else
  echo; echo Not Confirmed, $0 exiting with no action...; echo
  exit
fi

##########################################################
# note, prior to running this script, # run the following: 
#
#    alias > $TAGA_DIR/aliasList.txt
##########################################################

# if confirmation, required, get the confirmation

if [ $CONFIRM_REQD -eq 1 ] ; then
   # ensure proper setup
   echo Please confirm that the following has been performed:
   echo "alias > $ALIAS_FILE"
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

cat $ALIAS_FILE > $ALIAS_STRIPPED_FILE

for item in $STRIP_LIST
do
   cat $ALIAS_STRIPPED_FILE | grep -i -v $item > /tmp/tmp.txt
   cp /tmp/tmp.txt $ALIAS_STRIPPED_FILE
done

echo; echo Created: $ALIAS_STRIPPED_FILE ; echo

