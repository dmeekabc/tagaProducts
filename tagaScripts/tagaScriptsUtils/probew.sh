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

# How often to check for specific anomalies? (i.e. MOD_VAL)
MOD_VAL=2

# basic sanity check, to ensure password updated etc
./basicSanityCheck.sh
if [ $? -eq 255 ]; then
  echo Basic Sanith Check Failed - see warning above - $0 Exiting...
  echo
  exit 255
fi

# counter
let i=0

while true
do

echo;date;echo

let MOD_CHECK_VAL=$i%$MOD_VAL
if [ $MOD_CHECK_VAL -eq 0 ] ; then
   echo Loop Count: $i : Checking for specific anomalies...
   echo
fi

# target loop
for target in $targetList
do

   # determine LOGIN ID for each target
   MYLOGIN_ID=`$TAGA_UTILS_DIR/loginIdLookup.sh $target | tail -n 1`

   if [ $MOD_CHECK_VAL -eq 0 ] ; then

      #echo i:$i Mod value: $MOD_VAL 

      # check disk usage
#      echo $target: `ssh -l $MYLOGIN_ID $target '$HOME/scripts/taga/tagaScripts/tagaScriptsUtils/checkDisk.sh'`
      echo `./iboaPaddedEcho.sh $target 15`: `ssh -l $MYLOGIN_ID $target '$HOME/scripts/taga/tagaScripts/tagaScriptsUtils/checkDisk.sh'`

      # check interface activity
      iptablewarn=`ssh -l $MYLOGIN_ID $target sudo /sbin/iptables --list | grep DROP | cut -c1-4`
      if [ $iptablewarn ] ; then
         echo
         echo WARNING: $target has iptables DROP Rules SET!!
         echo WARNING: $target has iptables DROP Rules SET!!
         echo WARNING: $target has iptables DROP Rules SET!!
         echo NOTE: You may use the \'iptdpu\' command on $target to UNSET DROP Rules.
         echo NOTE: You may use the \'iptdpu\' command on $target to UNSET DROP Rules.
         echo
      fi

      # go to next target
      continue

   fi

   if echo $BLACKLIST | grep $target ; then
      echo The $target is in the black list, skipping...
      continue
   else
      echo; echo `date` : probing $target
     # echo `basename $0` processing $target .......
      echo $target: `ssh -l $MYLOGIN_ID $target hostname`
      echo $target: `ssh -l $MYLOGIN_ID $target date`
      echo $target: `ssh -l $MYLOGIN_ID $target uptime`
      echo $target: `ssh -l $MYLOGIN_ID $target /sbin/ifconfig | grep HWaddr`
   fi

   # end of target loop
done
echo

# increment the outer loop counter
let i=$i+1
# end of outer loop
done
