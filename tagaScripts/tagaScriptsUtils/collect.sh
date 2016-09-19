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

outputDir=$1

for target in $targetList
do

   # determine LOGIN ID for each target
   MYLOGIN_ID=`$TAGA_UTILS_DIR/loginIdLookup.sh $target | tail -n 1`
   # dlm temp , I have no clue why this is needed but it is...
   MYLOGIN_ID=`echo $MYLOGIN_ID` 

   echo
   echo processing, collecting files from $target start:`date | cut -c12-20`

   # if we are in local mode and target == MYIP , do not use ssh or scp
   if cat $TAGA_LOCAL_MODE_FLAG_FILE 2>/dev/null | grep 1 >/dev/null ; then
      if [ $target == $MYIP ]; then
        # collect
        cp /tmp/$TEST_DESCRIPTION* $outputDir
        cp /tmp/tagaRun* $outputDir
        # clean
        rm /tmp/$TEST_DESCRIPTION* 2>/dev/null 
      else
        # collect
        scp $MYLOGIN_ID@$target:/tmp/$TEST_DESCRIPTION* $outputDir
        scp $MYLOGIN_ID@$target:/tmp/tagaRun* $outputDir
        # clean
        ssh -l $MYLOGIN_ID $target rm /tmp/$TEST_DESCRIPTION* 2>/dev/null 
      fi

   # normal mode
   else
      # collect
      scp $MYLOGIN_ID@$target:/tmp/$TEST_DESCRIPTION* $outputDir
      scp $MYLOGIN_ID@$target:/tmp/tagaRun* $outputDir
      # clean
      ssh -l $MYLOGIN_ID $target rm /tmp/$TEST_DESCRIPTION* 2>/dev/null 
   fi

   echo processing, collecting files from $target  stop :`date | cut -c12-20`

done

echo
echo `basename $0` : Total File Count: `ls $outputDir | wc -l` Total Line Count: `cat $outputDir/* | wc -l`
echo

