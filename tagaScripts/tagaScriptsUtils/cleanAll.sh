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

MYLOCALLOGIN_ID=`$TAGA_UTILS_DIR/loginIdLookup.sh $MYIP | tail -n 1`
MYLOCALLOGIN_ID=`echo $MYLOCALLOGIN_ID`

for target in $targetList
do
   TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
   source $TAGA_CONFIG_DIR/config

   # determine LOGIN ID for each target
   MYLOGIN_ID=`$TAGA_UTILS_DIR/loginIdLookup.sh $target | tail -n 1`
   # dlm temp , I have no clue why this is needed but it is...
   MYLOGIN_ID=`echo $MYLOGIN_ID` 

   remotetagaScriptsUtilsDir=`echo $tagaScriptsUtilsDir | sed -e s/$MYLOCALLOGIN_ID/MYLOGIN_ID/g`
   remotetagaScriptsUtilsDir=`echo $remotetagaScriptsUtilsDir | sed -e s/MYLOGIN_ID/$MYLOGIN_ID/g`

   if cat $TAGA_LOCAL_MODE_FLAG_FILE 2>/dev/null | grep 1 >/dev/null ; then
      # do not use ssh if target == MYIP and local mode flag set
      if [ $target == $MYIP ]; then
        echo processing, cleaning $target
        $tagaScriptsUtilsDir/managedExecute.sh "$tagaScriptsUtilsDir/clean.sh"
      else
        echo processing, cleaning $target
        echo "ssh -l $MYLOGIN_ID $target $remotetagaScriptsUtilsDir/clean.sh" > /tmp/managedExecuteScript.sh
        chmod 755 /tmp/managedExecuteScript.sh
        $tagaScriptsUtilsDir/managedExecute.sh /tmp/managedExecuteScript.sh
        #ssh -l $MYLOGIN_ID $target $tagaScriptsUtilsDir/clean.sh
      fi
   else
        echo processing, cleaning $target
        echo "ssh -l $MYLOGIN_ID $target $remotetagaScriptsUtilsDir/clean.sh" > /tmp/managedExecuteScript.sh
        chmod 755 /tmp/managedExecuteScript.sh
        $tagaScriptsUtilsDir/managedExecute.sh /tmp/managedExecuteScript.sh
        #$tagaScriptsUtilsDir/managedExecute.sh "ssh -l $MYLOGIN_ID $target $tagaScriptsUtilsDir/clean.sh"
        #ssh -l $MYLOGIN_ID $target $tagaScriptsUtilsDir/clean.sh
   fi
done

