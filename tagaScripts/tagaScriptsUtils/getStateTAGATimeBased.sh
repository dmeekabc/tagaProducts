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

VERBOSE=0
VERBOSE=1

#output=""

let i=0
let j=0

for target in $targetList
do

   let i=$i+1

   if [ $VERBOSE -eq 1 ] ; then
      echo `date` : $target
   fi

   # determine LOGIN ID for each target
   MYLOGIN_ID=`$TAGA_UTILS_DIR/loginIdLookup.sh $target | tail -n 1`
   MYLOGIN_ID=`echo $MYLOGIN_ID`  # strip trailing blanks

   identy=$HOME/.ssh/id_rsa
   state=`ssh -i $identy -l $MYLOGIN_ID $target cat /var/opt/taga/run/tagaState.dat`
   tmp=`echo "\`/home/darrin/scripts/taga/iboaUtils/iboaPaddedEcho.sh $target 16\`: $state"`
   eval "mytarget$i=$tmp"

done

# Wait until top of minute

while true
do
   mydate=`date`
   seconds=`echo $mydate | cut -c18-19`

   let remaining=60-$seconds 2>/dev/null

   if [ $VERBOSE -eq 1 ] ; then
      #echo Next Update in $remaining seconds
      echo Next Update in $remaining seconds >/dev/null
   fi

   # dlm temp, replace range 2-5 with range check and add ors for the others
   if [ $remaining -eq 1 ] 2>/dev/null; then
      echo Next Update in $remaining seconds >/dev/null
      # do not sleep here, let fast loop below do it
      # do not print at 1 second since it prints too many times
   elif [ $remaining -eq 2 ] 2>/dev/null; then
      echo Next Update in $remaining seconds
      sleep 1
   elif [ $remaining -eq 3 ] 2>/dev/null; then
      echo Next Update in $remaining seconds
      sleep 1
   elif [ $remaining -eq 4 ] 2>/dev/null; then
      echo Next Update in $remaining seconds
      sleep 1
   elif [ $remaining -eq 5 ] 2>/dev/null; then
      echo Next Update in $remaining seconds
      sleep 1
   elif [ $remaining -eq 10 ] 2>/dev/null; then
      echo Next Update in 10 seconds
      ~/scripts/taga/iboaUtils/iboaDelay.sh 10
      #sleep 1
   elif [ $remaining -eq 11 ] 2>/dev/null; then
      echo Next Update in 10 seconds
      ~/scripts/taga/iboaUtils/iboaDelay.sh 10
      #sleep 1
   elif [ $remaining -eq 20 ] 2>/dev/null; then
      echo Next Update in $remaining seconds
      sleep 1
   elif [ $remaining -eq 30 ] 2>/dev/null; then
      echo Next Update in $remaining seconds
      sleep 1
   elif [ $remaining -eq 40 ] 2>/dev/null; then
      echo Next Update in $remaining seconds
      sleep 1
   elif [ $remaining -eq 50 ] 2>/dev/null; then
      echo Next Update in $remaining seconds
      sleep 1
   else
      sleep 1
   fi

   # we should not get past the '00' case but just to be sure...
   if [ $seconds == "00" ]; then
      break
   elif [ $seconds == "01" ]; then
      break
   elif [ $seconds == "02" ]; then
      break
   elif [ $seconds == "03" ]; then
      break
   elif [ $seconds == "04" ]; then
      break
   elif [ $seconds == "05" ]; then
      break
   else
      # do something to chew some time but less than 1 second
      echo `date` sleeping >> /tmp/sleeping.txt
   fi
done


# Okay, do the output here!
clear
sleep 1
echo
echo ---------------------------------------------------------
echo TAGA Timer-based Monitoring Status
echo ---------------------------------------------------------
echo $mydate
echo ---------------------------------------------------------
while [ $j -le $i ] 
do
   let j=$j+1
   eval "echo \$mytarget$j"
done



