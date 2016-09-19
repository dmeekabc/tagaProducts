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

# dlm temp do not do this for now

#if [ 1 ]; then

NET_REBOOT_ENABLED=1
NET_REBOOT_ENABLED=0

if [ $NET_REBOOT_ENABLED -eq 1 ]; then
   echo NOTICE: $0 is called and is enabled, $0 rebooting/resetting the network
   echo NOTICE: $0 is called and is enabled, $0 rebooting/resetting the network
else
   echo NOTICE: $0 has been called but is disabled, $0 exiting with no action.
   echo NOTICE: $0 has been called but is disabled, $0 exiting with no action.
   exit
fi


#echo
#echo WARNING: This command will reboot the following: $OTHER_LIST
#echo
#echo Are you sure? \(y/n\) ?
#echo
#
## issue confirmation prompt
#$iboaUtilsDir/confirm.sh
#
#let response=$?
#if [ $response -eq 1 ]; then
#  echo; echo Rebooting $OTHER_LIST ....; echo
#else
#  echo; echo Reboot $OTHER_LIST Command Not Confirmed, Exiting without action...; echo
#  exit
#fi
#


# parameter implies DO NOT reset the interface which is default
# default is to reset the interface
# override parameter indicates DO NOT reset the interface

if [ $# -eq 1 ] ; then
   echo skipping interface reset >/dev/null
else

# reset our interface
echo Interface is in suspect state - resetting! 
echo Interface is in suspect state - setting interface down!
sudo /sbin/ifconfig $INTERFACE  down < $TAGA_CONFIG_DIR/passwd.txt
echo Retcode:$?
sleep 5
echo Interface is in suspect state - setting interface up!
sudo /sbin/ifconfig $INTERFACE  up < $TAGA_CONFIG_DIR/passwd.txt
echo Retcode:$?

fi

##########################################
##########################################
##########################################

echo `basename $0` Recovering Network \(Rebooting Others\)
echo `basename $0` Recovering Network \(Rebooting Others\)
echo `basename $0` Recovering Network \(Rebooting Others\)

# let interface recover from /sbin/ifconfig command above
sleep 5


for i in 1 2 3 4 5 #6 7 9 9 10 
do
# reboot
#for target in $OTHER_LIST
for target in $REBOOT_LIST
do
   echo
   echo processing $target
   if [ $target == $MYIP ]; then
      echo skipping self for now...
      continue
   fi
   echo rebooting $target .....
   ssh -l $MYLOGIN_ID $target sudo reboot <$TAGA_CONFIG_DIR/passwd.txt &

done
sleep 2
echo
done




echo
echo Suspending while other nodes recover...
echo
$IBOA_UTILS_DIR/iboaDelay.sh 60 5
echo; echo Proceeding...; echo
