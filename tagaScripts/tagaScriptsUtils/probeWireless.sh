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

TAGA_DIR=$HOME/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

# basic sanity check, to ensure password updated etc
./basicSanityCheck.sh
if [ $? -eq 255 ]; then
  echo Basic Sanith Check Failed - see warning above - $0 Exiting...
  echo
  exit 255
fi

for target in $targetList
do

    # determine LOGIN ID for each target
    MYLOGIN_ID=`$TAGA_UTILS_DIR/loginIdLookup.sh $target | tail -n 1`
    # strip trailing blanks
    MYLOGIN_ID=`echo $MYLOGIN_ID` 

    #WIRELESS_INTERFACE="wlan0"

    WIRELESS_INTERFACE=`ssh -l $MYLOGIN_ID $target /sbin/ifconfig | grep HWaddr | grep ^wl | cut -d" " -f 1`

    #echo $WIRELESS_INTERFACE
    #continue


   if echo $BLACKLIST | grep $target ; then
      echo The $target is in the black list, skipping...
      continue
   else
      echo; echo `date` : probing $target
      echo $target: `ssh -l $MYLOGIN_ID $target /sbin/iwconfig $WIRELESS_INTERFACE `
      echo $target: `ssh -l $MYLOGIN_ID $target /sbin/iw $WIRELESS_INTERFACE info`

      #echo $target: `ssh -l $MYLOGIN_ID $target /sbin/iwconfig wlan0`
      #echo $target: `ssh -l $MYLOGIN_ID $target /sbin/iw wlan0 info`

      # echo DateBefore: $target: `ssh -l $MYLOGIN_ID $target date`
#      echo $target: `ssh -l $MYLOGIN_ID $target sudo /bin/date 072912202016`
      # echo $target: `ssh -l $MYLOGIN_ID $target sudo /bin/date 092215252016`
      # echo DateAfter: $target: `ssh -l $MYLOGIN_ID $target date`
     # echo `basename $0` processing $target .......
  #    echo $target: `ssh -l $MYLOGIN_ID $target hostname`
  #    echo $target: `ssh -l $MYLOGIN_ID $target date`

  #    echo $target: `ssh -l $MYLOGIN_ID $target cat /tmp/normRozn*.log | grep Server | grep id`

#      echo $target: `ssh -l $MYLOGIN_ID $target /sbin/iwconfig wlan1 `
#      echo $target: `ssh -l $MYLOGIN_ID $target /sbin/iw wlan1 info `
#      echo $target: `ssh -l $MYLOGIN_ID $target /sbin/iw list`
#      echo
#      echo
#      echo $target: `ssh -l $MYLOGIN_ID $target traceroute 192.168.41.221`
#      echo
#      echo
#      echo $target: `ssh -l $MYLOGIN_ID $target /sbin/ip route`
#      echo $target: `ssh -l $MYLOGIN_ID $target /sbin/route`
  #    echo $target: `ssh -l $MYLOGIN_ID $target uptime`
#      echo $target: `ssh -l $MYLOGIN_ID $target ps -ef | grep mgen`
#      echo $target: `ssh -l $MYLOGIN_ID $target ps -ef | grep netconf`
  #    echo $target: `ssh -l $MYLOGIN_ID $target /sbin/ifconfig | grep HWaddr`
   fi
done
echo
