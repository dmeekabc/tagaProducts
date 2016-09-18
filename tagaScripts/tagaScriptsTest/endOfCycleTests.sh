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

# set defaults; support operation without input
iter=0

TEST_LABEL="Config1" # default to Config1


# get the input (iteration number and test label) if provided
if [ $# -ge 1 ] ; then
  iter=$1
fi
if [ $# -ge 2 ] ; then
  TEST_LABEL=$2
fi

# init cleanup 
rm /tmp/mark* 2>/dev/null

NAME=`basename $0`
IPPART=`$iboaUtilsDir/iboa_padded_echo.sh $MYIP $IP_PAD_LEN`
NAMEPART=`$iboaUtilsDir/iboa_padded_echo.sh $NAME $NAME_PAD_LEN`

if [ $END_OF_CYCLE_TESTS1_ENABLED == 1 ]; then
  if [ $TAGA_DISPLAY_SETTING -ge $TAGA_DISPLAY_ENUM_VAL_4_VERBOSE ]; then
    echo "$IPPART : $NAMEPART : executing at `date`"
  fi
#  echo `basename $0` Start of Cycle Tests 1 Enabled - proceeding...
else
  if [ $TAGA_DISPLAY_SETTING -ge $TAGA_DISPLAY_ENUM_VAL_4_VERBOSE ]; then
    echo "$IPPART : $NAMEPART : disabled at `date`"
  fi
#  echo `basename $0` Start of Cycle Tests 1 Disabled - Exiting
  exit
fi

echo $0 : Test Label : $TEST_LABEL

# If we get here, we are enabled, we need to remove (unset) the  
# "complete" flag file and create (set) our "in progress" flag file

rm /tmp/mark.out 2>/dev/null
rm /tmp/markSecs1.dat 2>/dev/null
rm /tmp/endOfCycleTests.sh.Complete.dat 2>/dev/null

#START TEST

echo "iter:$iter TEST:$TEST_LABEL In Progress" > /tmp/endOfCycleTests.sh.InProgress.dat
echo StartDTG: `date` > /tmp/endOfCycleTest.dat

#mark1 begin
date -Ins > /tmp/mark.out

#mark2 begin
~/scripts/taga/tagaScripts/tagaScriptsTimer/timeDeltaCalcSeconds.sh endOfCycleTestTimer


PAD=""
PAD0="..."

# simulate a test
echo Simulating a Test for 10 seconds...
for i in 1 2 3 4 5 6 7 8 9 10
do
   PAD="$PAD$PAD0"
  #echo $PAD$i
  echo $i$PAD
  sleep 1
done
echo DONE Simulating a Test for 10 seconds...

# WE are DONE
echo StopDTG:: `date` >> /tmp/endOfCycleTestTimer.dat

#mark1 end
~/scripts/taga/tagaScripts/tagaScriptsTimer/timeDeltaCalc.sh > /tmp/endOfCycleTestTimer.dat
rm /tmp/mark.out 2>/dev/null

#mark2 end
~/scripts/taga/tagaScripts/tagaScriptsTimer/timeDeltaCalcSeconds.sh endOfCycleTestTimer > /tmp/endOfCycleTestTimer_mark.dat

echo iter:$iter: $TEST:$TEST_LABEL: `cat /tmp/endOfCycleTestTimer_mark.dat` >> /tmp/endOfCycleTestTimer_mark_cum.dat
echo iter:$iter: $TEST:$TEST_LABEL: `cat /tmp/endOfCycleTestTimer_mark.dat` >> /tmp/endOfCycleTestTimer_mark_cum.dat

echo;echo; echo /tmp/endOfCycleTestTimer.dat; echo -------------; cat /tmp/endOfCycleTestTimer.dat
echo;echo; echo /tmp/endOfCycleTestTimer_mark.dat; echo -------------; cat /tmp/endOfCycleTestTimer_mark.dat
echo;echo; echo /tmp/endOfCycleTestTimer_mark_cum.dat; echo -------------; cat /tmp/endOfCycleTestTimer_mark_cum.dat

echo;echo; echo /tmp/endOfCycleTestTimer.dat; echo -------------; cat /tmp/endOfCycleTestTimer.dat
echo;echo; echo /tmp/endOfCycleTestTimer_mark.dat; echo -------------; cat /tmp/endOfCycleTestTimer_mark.dat
echo;echo; echo /tmp/endOfCycleTestTimer_mark_cum.dat; echo -------------; cat /tmp/endOfCycleTestTimer_mark_cum.dat
echo;echo; 

# Clear the "In Progress" and Set the "Complete" Flag Files

rm /tmp/endOfCycleTests.sh.InProgress.dat
echo Complete > /tmp/endOfCycleTests.sh.Complete.dat

