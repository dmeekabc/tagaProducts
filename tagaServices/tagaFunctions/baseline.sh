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

VERBOSE=1
VERBOSE=0

let DURATION=12   # 12 Second Baseline
let DURATION=3600 # 60 Minute Baseline
let DURATION=120  # Two Minute Baseline
let DURATION=600  # Ten Minute Baseline
let DURATION=60   # One Minute Baseline

echo; echo $0 : $MYIP :  executing at `date`; echo
LOG_FILE=/tmp/`basename $0`.log
echo $0 : $MYIP :  executing at `date` > $LOG_FILE

if [ $VERBOSE -eq 1 ] ; then
myuptime=`uptime | cut -d" " -f 3-5`
echo INTERFACE: $INTERFACE $myuptime; echo
else
myuptime=`uptime | cut -d" " -f 3-5`
echo INTERFACE: $INTERFACE $myuptime; echo
fi

if [ $VERBOSE -eq 1 ] ; then
   /sbin/ifconfig | grep -A 10 $INTERFACE
   echo
   echo
fi

/sbin/ifconfig | grep -A 10 $INTERFACE | grep "RX bytes"

let rxBytes=`/sbin/ifconfig | grep -A 10 $INTERFACE | grep "RX bytes" | cut -d: -f 2 | cut -d" " -f 1`
let txBytes=`/sbin/ifconfig | grep -A 10 $INTERFACE | grep "RX bytes" | cut -d: -f 3 | cut -d" " -f 1`

let startRxBytes=$rxBytes
let startTxBytes=$txBytes

if [ $VERBOSE -eq 1 ] ; then
echo
echo

echo Start RxBytes:$rxBytes
echo Start TxBytes:$txBytes
fi

$iboaUtilsDir/iboaDelay.sh $DURATION

let rxBytes=`/sbin/ifconfig | grep -A 10 $INTERFACE | grep "RX bytes" | cut -d: -f 2 | cut -d" " -f 1`
let txBytes=`/sbin/ifconfig | grep -A 10 $INTERFACE | grep "RX bytes" | cut -d: -f 3 | cut -d" " -f 1`

#echo
#echo

if [ $VERBOSE -eq 1 ] ; then
echo End RxBytes:$rxBytes
echo End TxBytes:$txBytes
fi

let endRxBytes=$rxBytes
let endTxBytes=$txBytes

#echo
echo

let deltaRxBytes=$endRxBytes-$startRxBytes
let deltaTxBytes=$endTxBytes-$startTxBytes

if [ $VERBOSE -eq 1 ] ; then
echo Delta RxBytes:$deltaRxBytes
echo Delta TxBytes:$deltaTxBytes
fi


let deltaRxBytesPerSec=$deltaRxBytes/$DURATION
let deltaTxBytesPerSec=$deltaTxBytes/$DURATION

if [ $VERBOSE -eq 1 ] ; then
echo
echo
echo Delta RxBytes Per Sec: $deltaRxBytesPerSec
echo Delta TxBytes Per Sec: $deltaTxBytesPerSec
echo
echo
fi

let deltaRxBitsPerSec=$deltaRxBytesPerSec*8
let deltaTxBitsPerSec=$deltaTxBytesPerSec*8

#if [ $VERBOSE -eq 1 ] ; then
echo
echo Delta Rx Bits Per Sec: $deltaRxBitsPerSec
echo Delta Tx Bits Per Sec: $deltaTxBitsPerSec
echo
#fi


if [ $deltaRxBitsPerSec -gt 1000 ] && [ $deltaTxBitsPerSec -gt 1000 ] ; then

   let rxKbps=$deltaRxBitsPerSec/1000
   let txKbps=$deltaTxBitsPerSec/1000
   echo
   echo -----------
   echo Baseline:
   echo -----------
   echo Rx: $rxKbps kbps
   echo Tx: $txKbps kbps
   echo

fi
