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

##################################################################
# MAIN
##################################################################

# start with fresh file
rm $TAGA_CONFIG_DIR/hostsToIps.txt 2>/dev/null
rm $TAGA_CONFIG_DIR/hostList.txt 2>/dev/null

if [ $REGEN_SHRARED_IP_FILE -eq 1 ] ; then
   # we will regen this file so clear it now
   rm $TAGA_CONFIG_DIR/hostsToSharedIps.txt 2>/dev/null
fi

echo

# build the hostList from the targetList
for target in $targetList
do
   # determine LOGIN ID for each target
   MYLOGIN_ID=`$TAGA_UTILS_DIR/loginIdLookup.sh $target | tail -n 1`
   # dlm temp , I have no clue why this is needed but it is...
   MYLOGIN_ID=`echo $MYLOGIN_ID` 

   if echo $BLACKLIST | grep $target >/dev/null ; then
      echo The $target is in the black list, skipping...
      continue
   else
      echo `basename $0` processing $target ....... >/dev/null
   fi

   # don't use ssh if local mode flag is set
   if cat $TAGA_LOCAL_MODE_FLAG_FILE 2>/dev/null | grep 1 >/dev/null ; then
      if [ $target == $MYIP ]; then
         processCount=`ps -ef | wc -l`           
         targethostname=`hostname` 
      else
         processCount=`ssh -l $MYLOGIN_ID $target ps -ef | wc -l`           
         targethostname=`ssh -l $MYLOGIN_ID $target hostname` 
      fi
   else
      processCount=`ssh -l $MYLOGIN_ID $target ps -ef | wc -l`           
      targethostname=`ssh -l $MYLOGIN_ID $target hostname` 
   fi

   # echo $target $targethostname \(process count: $processCount\)

   # build up the buffer
   buffer1="$target $targethostname"

   # pad the buffer
   buflen=`echo $buffer1 | awk '{print length($0)}'`
   let ROW_SIZE=56
   let ROW_SIZE=52
   let padlen=$ROW_SIZE-$buflen

   # add the padding
   let i=$padlen
   while [ $i -gt 0 ];
   do
     buffer1="$buffer1."
     let i=$i-1
   done

   # add the percent at the end of the buffer
   buffer2="$buffer1 (process count: $processCount)"

   # write buffer line to output
   echo $buffer2 


  alternateIps=`ssh -l $MYLOGIN_ID $target /sbin/ifconfig | grep "inet addr" | grep -v $target | grep -v 127.0.0.1 | cut -d: -f 2 | cut -d" " -f 1 | head -n 1`

   #echo alternateIps: $alternateIps


   # write the hostList.txt and hostsToIps.txt files
   echo $targethostname >> $TAGA_CONFIG_DIR/hostList.txt
   echo $target.$targethostname >> $TAGA_CONFIG_DIR/hostsToIps.txt

   # write to the shared IP file if the flag is set
   if [ $REGEN_SHRARED_IP_FILE -eq 1 ] ; then
      echo $target.$targethostname.$alternateIps >> $TAGA_CONFIG_DIR/hostsToSharedIps.txt
   fi



done
echo


