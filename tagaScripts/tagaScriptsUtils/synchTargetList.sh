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

EXTENSION_FILE=$tagaConfigDir/targetListExtension.txt

let DEBUG=1
let DEBUG=0

let successCount=1

while [ $successCount -lt $TARGET_COUNT ] 

do

# re-source the config in case it changed...
source $TAGA_CONFIG_DIR/config

let successCount=1

for target in $targetList
do

   # determine LOGIN ID for each target
   MYLOGIN_ID=`$TAGA_UTILS_DIR/loginIdLookup.sh $target | tail -n 1`
   # strip trailing blanks
   MYLOGIN_ID=`echo $MYLOGIN_ID` 

   if [ $target == $MYIP ] ; then
     echo
     echo skipping self \($target\) ...
     echo
     continue
   else
     echo
     echo processing, synchronizing $target

     # send the files to the destination

     # Check for the extension file
     if [ -f $EXTENSION_FILE ]; then
        # Synch the Extension Also if It Exists
        if [ $DEBUG -eq 1 ] ; then
           echo "scp $tagaConfigDir/targetList.sh $EXTENSION_FILE $MYLOGIN_ID@$target:$tagaConfigDir"
        fi
        scp $tagaConfigDir/targetList.sh $EXTENSION_FILE $MYLOGIN_ID@$target:$tagaConfigDir 
     else
        if [ $DEBUG -eq 1 ] ; then
           echo "scp $tagaConfigDir/targetList.sh $MYLOGIN_ID@$target:$tagaConfigDir" 
        fi
        scp $tagaConfigDir/targetList.sh $MYLOGIN_ID@$target:$tagaConfigDir 
     fi

     RETCODE=$?
     if [ $RETCODE -eq 0 ] ; then
        let successCount=$successCount+1
     fi

     # Check for ABSENCE of the extension file
     if ! [ -f $EXTENSION_FILE ]; then
        if [ $DEBUG -eq 1 ] ; then
           echo  Ensure there are not stragglers, delete Extensions from all nodes
           echo "ssh -l $MYLOGIN_ID $target rm $EXTENSION_FILE"
        fi
        ssh -l $MYLOGIN_ID $target rm $EXTENSION_FILE  2>/dev/null  &  # Do it in background to speed it up
     else
        echo  Nothing Left to do >/dev/null
     fi

   fi
done

echo
sleep 2
let printCount=$successCount-1

if [ $successCount -lt $TARGET_COUNT ] ; then
   echo "$printCount targets received the update, do you want to try again (y/n)?"

   autoConfirm=`$tagaUtilsDir/getAutoConfirm.sh | cut -d: -f 2`

   if [ $autoConfirm -eq 1 ] ; then 
      echo Auto-confirmed, proceeding...
   else
      # get input from user
      read input
      if [ $input == "n" ] ; then
         echo "WARNING: $printCount of $TARGET_COUNT targets received the update, not all targets were updated!"
         echo
         sleep 1
         exit
      fi 
      echo proceeding...
   fi

else
   echo "$printCount targets received the update, Success!"
   echo
   sleep 2
fi

done
