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
# remove trailing white space
MYLOCALLOGIN_ID=`echo $MYLOCALLOGIN_ID`

# change to config dir
cd $TAGA_CONFIG_DIR >/dev/null

# touch it to eliminate warnings if not present
touch config_overrides

for target in $targetList
do

   TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
   source $TAGA_CONFIG_DIR/config

   # determine LOGIN ID for each target
   MYLOGIN_ID=`$TAGA_UTILS_DIR/loginIdLookup.sh $target | tail -n 1`
   # remove trailing white space
   MYLOGIN_ID=`echo $MYLOGIN_ID` 

   TAGA_CONFIG_DIR=`echo $TAGA_CONFIG_DIR | sed -e s/$MYLOCALLOGIN_ID/MYLOGIN_ID/g`
   TAGA_CONFIG_DIR=`echo $TAGA_CONFIG_DIR | sed -e s/MYLOGIN_ID/$MYLOGIN_ID/g`

   # set the  synchIP.dat file flag to invoke the countWhile util
   echo 1 > /tmp/$target.synchIP.dat

   echo processing, synchronizing config $target
   #echo $target : synching config
   # start countoff in background
   $TAGA_UTILS_DIR/countWhile.sh /tmp/$target.synchIP.dat &

   #echo processing, synchronizing config $target

   # build the source file string
   SCP_SOURCE_STR="$SCP_SOURCE_STR config"
   SCP_SOURCE_STR="$SCP_SOURCE_STR config_admin"
   SCP_SOURCE_STR="$SCP_SOURCE_STR config_overrides" # config overrides ARE synchronized
   #SCP_SOURCE_STR="$SCP_SOURCE_STR config_extensions" # config extensions ARE NOT synchronized
   SCP_SOURCE_STR="$SCP_SOURCE_STR targetList.sh"
   SCP_SOURCE_STR="$SCP_SOURCE_STR hostList.txt"
   SCP_SOURCE_STR="$SCP_SOURCE_STR midsizeTargetList.txt"
   SCP_SOURCE_STR="$SCP_SOURCE_STR largeTargetList.txt"

   # do not use scp if target == MYIP and local mode flag set
   if cat $TAGA_LOCAL_MODE_FLAG_FILE 2>/dev/null | grep 1 >/dev/null ; then
      if [ $target == $MYIP ]; then
         # send the files to the destination
         #cp $SCP_SOURCE_STR $TAGA_CONFIG_DIR <$TAGA_CONFIG_DIR/passwd.txt
         cp $SCP_SOURCE_STR $TAGA_CONFIG_DIR # <$TAGA_CONFIG_DIR/passwd.txt
      else
         # send the files to the destination
         #scp $SCP_SOURCE_STR $MYLOGIN_ID@$target:$TAGA_CONFIG_DIR <$TAGA_CONFIG_DIR/passwd.txt
         scp $SCP_SOURCE_STR $MYLOGIN_ID@$target:$TAGA_CONFIG_DIR # <$TAGA_CONFIG_DIR/passwd.txt
      fi
   else
      # send the files to the destination
      #scp $SCP_SOURCE_STR $MYLOGIN_ID@$target:$TAGA_CONFIG_DIR <$TAGA_CONFIG_DIR/passwd.txt
      scp $SCP_SOURCE_STR $MYLOGIN_ID@$target:$TAGA_CONFIG_DIR # <$TAGA_CONFIG_DIR/passwd.txt
   fi

   # clear the synchIP.dat file flag to stop the countWhile util
   rm /tmp/$target.synchIP.dat

done

# change to orig dir
cd - >/dev/null




