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


# If We are not a Single Invocation and First time in then print init msg...
if [ $# -eq 0 ] ; then
   echo; echo $0 Initializing...
fi

### Align to 5 second boundary before proceeding
#####$tagaTimerDir/fiveSecond.sh >/dev/null

let TX_STATS=`$tagaScriptsStatsDir/adminstats.sh TXonly`
let RX_STATS=`$tagaScriptsStatsDir/adminstats.sh RXonly`
let START_TX_STATS=$TX_STATS
let START_RX_STATS=$RX_STATS

let iter=0

STARTDATE=`date`
START_STATS=`$tagaScriptsStatsDir/adminstats.sh` 

let START_SECS=`date +%s`

while true
do

   let iter=$iter+1

   # Sleep to gett the data for a 10 second cycle
   sleep 8

   CURRENTDATE=`date`
   CURRENT_STATS=`$tagaScriptsStatsDir/adminstats.sh`

   let CURRENT_SECS=`date +%s`
   let DELTA_SECS=$CURRENT_SECS-$START_SECS
   let SECS_PER_ITER=$DELTA_SECS/$iter

   #
   # Algorithm:
   # Print the Cumulative and Average Rates here 
   # The current rates are printed at bottom of loop but beginning of 10 sec cycle
   #

   # Any flag parameter is indicator to exit after one iteration
   if [ $# -gt 0 ] ; then
      # Special Header
      echo
      echo $MYIP
      #echo "CURRENT (Non-cumulative) DATA : $CURRENTDATE"
      echo $CURRENTDATE
      echo "CURRENT (Non-cumulative) DATA"
      IterString="ONE"
   else
      # Normal Header
      echo
      echo $MYIP
      #echo "CUMULATIVE (and Average) DATA : $CURRENTDATE"
      echo $CURRENTDATE
      echo "CUMULATIVE (and Average) DATA"
      IterString="AVG"
   fi

   echo START DTG: $STARTDATE  CURRENT DTG: $CURRENTDATE
   echo "TAGA:Iter:$iter ITFC START:   $START_STATS"
   echo "TAGA:Iter:$iter ITFC CURRENT: $CURRENT_STATS"

   let TX_STATS=`$tagaScriptsStatsDir/adminstats.sh TXonly`
   let RX_STATS=`$tagaScriptsStatsDir/adminstats.sh RXonly`
   let CURRENT_TX_STATS=$TX_STATS
   let CURRENT_RX_STATS=$RX_STATS
   let DELTA_TX_STATS=$CURRENT_TX_STATS-$START_TX_STATS
   let DELTA_RX_STATS=$CURRENT_RX_STATS-$START_RX_STATS

# GitHub Note: Consider refactoring the below four big blocks into a single script file
# .. several input params will be required

   wordlen=`echo $DELTA_RX_STATS | awk '{print length($0)}'`

   if [ $wordlen -eq 8 ]; then
      let MBytes=$DELTA_RX_STATS*10 # multiply by 10 to get fraction
      let MBytes=$MBytes/1000000
      megabytePrint=`echo $MBytes | cut -c1-2`.`echo $MBytes | cut -c3`
      echo "TAGA:Iter:$iter DELTA_RX_STATS:      $DELTA_RX_STATS ($megabytePrint MB RX)"
   elif [ $wordlen -eq 7 ]; then
      let MBytes=$DELTA_RX_STATS*10 # multiply by 10 to get fraction
      let MBytes=$MBytes/1000000
      megabytePrint=`echo $MBytes | cut -c1`.`echo $MBytes | cut -c2`
      echo "TAGA:Iter:$iter DELTA_RX_STATS:      $DELTA_RX_STATS ($megabytePrint MB RX)"
   elif [ $wordlen -eq 6 ]; then
      let KBytes=$DELTA_RX_STATS*10 # multiply by 10 to get fraction
      let KBytes=$KBytes/1000
      kilobytePrint=`echo $KBytes | cut -c1-3`.`echo $KBytes | cut -c4`
      echo "TAGA:Iter:$iter DELTA_RX_STATS:      $DELTA_RX_STATS ($kilobytePrint KB RX)"
   elif [ $wordlen -eq 5 ]; then
      let KBytes=$DELTA_RX_STATS*10 # multiply by 10 to get fraction
      let KBytes=$KBytes/1000
      kilobytePrint=`echo $KBytes | cut -c1-2`.`echo $KBytes | cut -c3-4`
      echo "TAGA:Iter:$iter DELTA_RX_STATS:      $DELTA_RX_STATS ($kilobytePrint KB RX)"
   elif [ $wordlen -eq 4 ]; then
      let KBytes=$DELTA_RX_STATS*10 # multiply by 10 to get fraction
      let KBytes=$KBytes/1000
      kilobytePrint=`echo $KBytes | cut -c1`.`echo $KBytes | cut -c2-4`
      echo "TAGA:Iter:$iter DELTA_RX_STATS:      $DELTA_RX_STATS ($kilobytePrint KB RX)"
   else
      echo "TAGA:Iter:$iter DELTA_RX_STATS:      $DELTA_RX_STATS" 
   fi

   wordlen=`echo $DELTA_TX_STATS | awk '{print length($0)}'`

   if [ $wordlen -eq 8 ]; then
      let MBytes=$DELTA_TX_STATS*10 # multiply by 10 to get fraction
      let MBytes=$MBytes/1000000
      megabytePrint=`echo $MBytes | cut -c1-2`.`echo $MBytes | cut -c3`
      echo "TAGA:Iter:$iter DELTA_TX_STATS:      $DELTA_TX_STATS ($megabytePrint MB TX)"
   elif [ $wordlen -eq 7 ]; then
      let MBytes=$DELTA_TX_STATS*10 # multiply by 10 to get fraction
      let MBytes=$MBytes/1000000
      megabytePrint=`echo $MBytes | cut -c1`.`echo $MBytes | cut -c2`
      echo "TAGA:Iter:$iter DELTA_TX_STATS:      $DELTA_TX_STATS ($megabytePrint MB TX)"
   elif [ $wordlen -eq 6 ]; then
      let KBytes=$DELTA_TX_STATS*10 # multiply by 10 to get fraction
      let KBytes=$KBytes/1000
      kilobytePrint=`echo $KBytes | cut -c1-3`.`echo $KBytes | cut -c4`
      echo "TAGA:Iter:$iter DELTA_TX_STATS:      $DELTA_TX_STATS ($kilobytePrint KB TX)"
   elif [ $wordlen -eq 5 ]; then
      let KBytes=$DELTA_TX_STATS*10 # multiply by 10 to get fraction
      let KBytes=$KBytes/1000
      kilobytePrint=`echo $KBytes | cut -c1-2`.`echo $KBytes | cut -c3-4`
      echo "TAGA:Iter:$iter DELTA_TX_STATS:      $DELTA_TX_STATS ($kilobytePrint KB TX)"
   elif [ $wordlen -eq 4 ]; then
      let KBytes=$DELTA_TX_STATS*10 # multiply by 10 to get fraction
      let KBytes=$KBytes/1000
      kilobytePrint=`echo $KBytes | cut -c1`.`echo $KBytes | cut -c2-4`
      echo "TAGA:Iter:$iter DELTA_TX_STATS:      $DELTA_TX_STATS ($kilobytePrint KB TX)"
   else
      echo "TAGA:Iter:$iter DELTA_TX_STATS:      $DELTA_TX_STATS" 
   fi

   let DELTA_RX_STATS_ITER=$DELTA_RX_STATS/$iter

   wordlen=`echo $DELTA_RX_STATS_ITER | awk '{print length($0)}'`
   if [ $wordlen -eq 8 ]; then
      let MBytes=$DELTA_RX_STATS_ITER*10 # multiply by 10 to get fraction
      let MBytes=$MBytes/1000000
      megabytePrint=`echo $MBytes | cut -c1-2`.`echo $MBytes | cut -c3`
      let kilobitPrint=$DELTA_RX_STATS_ITER*8 # convert to bits
      let kilobitPrint=$kilobitPrint/$SECS_PER_ITER # convert based on iteration duration
      let kilobitPrint=$kilobitPrint/1000 # 1000 ms per second
      echo "TAGA:Iter:$iter DELTA_RX_STATS_ITER_$IterString: $DELTA_RX_STATS_ITER ($megabytePrint MB RX per $SECS_PER_ITER sec Iter) ($kilobitPrint kbps RX)"
   elif [ $wordlen -eq 7 ]; then
      let MBytes=$DELTA_RX_STATS_ITER*10 # multiply by 10 to get fraction
      let MBytes=$MBytes/1000000
      megabytePrint=`echo $MBytes | cut -c1`.`echo $MBytes | cut -c2`
      let kilobitPrint=$DELTA_RX_STATS_ITER*8 # convert to bits
      let kilobitPrint=$kilobitPrint/$SECS_PER_ITER # convert based on iteration duration
      let kilobitPrint=$kilobitPrint/1000 # 1000 ms per second
      echo "TAGA:Iter:$iter DELTA_RX_STATS_ITER_$IterString: $DELTA_RX_STATS_ITER ($megabytePrint MB RX per $SECS_PER_ITER sec Iter) ($kilobitPrint kbps RX)"
   elif [ $wordlen -eq 6 ]; then
      let KBytes=$DELTA_RX_STATS_ITER*10 # multiply by 10 to get fraction
      let KBytes=$KBytes/1000
      kilobytePrint=`echo $KBytes | cut -c1-3`.`echo $KBytes | cut -c4`
      let kilobitPrint=$DELTA_RX_STATS_ITER*8 # convert to bits
      #let kilobitPrint=$kilobitPrint/5000 # five secs, 5000 ms,  per iteration
      let kilobitPrint=$kilobitPrint/$SECS_PER_ITER # convert based on iteration duration
      let kilobitPrint=$kilobitPrint/1000 # 1000 ms per second
      echo "TAGA:Iter:$iter DELTA_RX_STATS_ITER_$IterString: $DELTA_RX_STATS_ITER ($kilobytePrint KB RX per $SECS_PER_ITER sec Iter) ($kilobitPrint kbps RX)"
   elif [ $wordlen -eq 5 ]; then
      let KBytes=$DELTA_RX_STATS_ITER*10 # multiply by 10 to get fraction
      let KBytes=$KBytes/1000
      kilobytePrint=`echo $KBytes | cut -c1-2`.`echo $KBytes | cut -c3-4`
      let kilobitPrint=$DELTA_RX_STATS_ITER*8 # convert to bits
      #let kilobitPrint=$kilobitPrint/5000 # five secs , 5000 ms, per iteration
      let kilobitPrint=$kilobitPrint/$SECS_PER_ITER # convert based on iteration duration
      let kilobitPrint=$kilobitPrint/1000 # 1000 ms per second
      echo "TAGA:Iter:$iter DELTA_RX_STATS_ITER_$IterString: $DELTA_RX_STATS_ITER ($kilobytePrint KB RX per $SECS_PER_ITER sec Iter) ($kilobitPrint kbps RX)"
   elif [ $wordlen -eq 4 ]; then
      let KBytes=$DELTA_RX_STATS_ITER*10 # multiply by 10 to get fraction
      let KBytes=$KBytes/1000
      kilobytePrint=`echo $KBytes | cut -c1`.`echo $KBytes | cut -c2-4`
      let kilobitPrint=$DELTA_RX_STATS_ITER*8 # convert to bits
      #let kilobitPrint=$kilobitPrint/5000 # five secs , 5000 ms, per iteration
      let kilobitPrint=$kilobitPrint/$SECS_PER_ITER # convert based on iteration duration
      let kilobitPrint=$kilobitPrint/1000 # 1000 ms per second
      echo "TAGA:Iter:$iter DELTA_RX_STATS_ITER_$IterString: $DELTA_RX_STATS_ITER ($kilobytePrint KB RX per $SECS_PER_ITER sec Iter) ($kilobitPrint kbps RX)"
   else
      echo TAGA:Iter:$iter DELTA_RX_STATS_ITER_$IterString: $DELTA_RX_STATS_ITER
   fi

   let DELTA_TX_STATS_ITER=$DELTA_TX_STATS/$iter

   wordlen=`echo $DELTA_TX_STATS_ITER | awk '{print length($0)}'`
   if [ $wordlen -eq 8 ]; then
      let MBytes=$DELTA_TX_STATS_ITER*10 # multiply by 10 to get fraction
      let MBytes=$MBytes/1000000
      megabytePrint=`echo $MBytes | cut -c1-2`.`echo $MBytes | cut -c3`
      let kilobitPrint=$DELTA_TX_STATS_ITER*8 # convert to bits
      let kilobitPrint=$kilobitPrint/$SECS_PER_ITER # convert based on iteration duration
      let kilobitPrint=$kilobitPrint/1000 # 1000 ms per second
      echo "TAGA:Iter:$iter DELTA_TX_STATS_ITER_$IterString: $DELTA_TX_STATS_ITER ($megabytePrint MB TX per $SECS_PER_ITER sec Iter) ($kilobitPrint kbps TX)"
   elif [ $wordlen -eq 7 ]; then
      let MBytes=$DELTA_TX_STATS_ITER*10 # multiply by 10 to get fraction
      let MBytes=$MBytes/1000000
      megabytePrint=`echo $MBytes | cut -c1`.`echo $MBytes | cut -c2`
      let kilobitPrint=$DELTA_TX_STATS_ITER*8 # convert to bits
      let kilobitPrint=$kilobitPrint/$SECS_PER_ITER # convert based on iteration duration
      let kilobitPrint=$kilobitPrint/1000 # 1000 ms per second
      echo "TAGA:Iter:$iter DELTA_TX_STATS_ITER_$IterString: $DELTA_TX_STATS_ITER ($megabytePrint MB TX per $SECS_PER_ITER sec Iter) ($kilobitPrint kbps TX)"
   elif [ $wordlen -eq 6 ]; then
      let KBytes=$DELTA_TX_STATS_ITER*10 # multiply by 10 to get fraction
      let KBytes=$KBytes/1000
      kilobytePrint=`echo $KBytes | cut -c1-3`.`echo $KBytes | cut -c4`
      let kilobitPrint=$DELTA_TX_STATS_ITER*8 # convert to bits
      #let kilobitPrint=$kilobitPrint/5000 # five secs , 5000 ms, per iteration
      let kilobitPrint=$kilobitPrint/$SECS_PER_ITER # convert based on iteration duration
      let kilobitPrint=$kilobitPrint/1000 # 1000 ms per second
      echo "TAGA:Iter:$iter DELTA_TX_STATS_ITER_$IterString: $DELTA_TX_STATS_ITER ($kilobytePrint KB TX per $SECS_PER_ITER sec Iter) ($kilobitPrint kbps TX)"
   elif [ $wordlen -eq 5 ]; then
      let KBytes=$DELTA_TX_STATS_ITER*10 # multiply by 10 to get fraction
      let KBytes=$KBytes/1000
      kilobytePrint=`echo $KBytes | cut -c1-2`.`echo $KBytes | cut -c3-4`
      let kilobitPrint=$DELTA_TX_STATS_ITER*8 # convert to bits
      #let kilobitPrint=$kilobitPrint/5000 # five secs , 5000 ms, per iteration
      let kilobitPrint=$kilobitPrint/$SECS_PER_ITER # convert based on iteration duration
      let kilobitPrint=$kilobitPrint/1000 # 1000 ms per second
      echo "TAGA:Iter:$iter DELTA_TX_STATS_ITER_$IterString: $DELTA_TX_STATS_ITER ($kilobytePrint KB TX per $SECS_PER_ITER sec Iter) ($kilobitPrint kbps TX)"
   elif [ $wordlen -eq 4 ]; then
      let KBytes=$DELTA_TX_STATS_ITER*10 # multiply by 10 to get fraction
      let KBytes=$KBytes/1000
      kilobytePrint=`echo $KBytes | cut -c1`.`echo $KBytes | cut -c2-4`
      let kilobitPrint=$DELTA_TX_STATS_ITER*8 # convert to bits
      #let kilobitPrint=$kilobitPrint/5000 # five secs , 5000 ms, per iteration
      let kilobitPrint=$kilobitPrint/$SECS_PER_ITER # convert based on iteration duration
      let kilobitPrint=$kilobitPrint/1000 # 1000 ms per second
      echo "TAGA:Iter:$iter DELTA_TX_STATS_ITER_$IterString: $DELTA_TX_STATS_ITER ($kilobytePrint KB TX per $SECS_PER_ITER sec Iter) ($kilobitPrint kbps TX)"
   else
      echo TAGA:Iter:$iter DELTA_TX_STATS_ITER_$IterString: $DELTA_TX_STATS_ITER
   fi

   # Any flag parameter is indicator to exit after one iteration
   if [ $# -gt 0 ] ; then
      echo Single Iteration Only Requested - Exiting! >/dev/null
      exit
   fi

   # otherwise, sleep and do it again!
   #sleep 8

   # Print the Current Rate here (call this script with single iter parameter)

   # Okay, do the interfaceMonitor.sh stuff!!
   $tagaUtilsDir/interfaceMonitor.sh oneIterationOnlyFlag

   ## otherwise, sleep for 5 and do it again!
   ## Align to 5 second boundary before proceeding
   ##$tagaTimerDir/fiveSecond.sh >/dev/null

done



