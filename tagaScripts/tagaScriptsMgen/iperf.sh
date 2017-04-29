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

echo; echo $0 : $MYIP :  executing at `date`; echo
LOG_FILE=/tmp/`basename $0`.log
echo $0 : $MYIP :  executing at `date` > $LOG_FILE

# dlm temp, udp only for now
mgen_proto=udp

if [ $TESTTYPE == "MCAST" ]; then
   mgen_proto=udp
   echo $0 $TESTTYPE Not yet implemented!
   exit
elif [ $TESTTYPE == "UCAST_TCP" ]; then
   mgen_proto=tcp
   echo $0 $TESTTYPE Not yet implemented!
   exit
else
   mgen_proto=udp
   echo UDP, we are Good to Go > /dev/null
fi

#####################################
# Function sendit
#####################################
function sendit {
   if [ $mgen_proto == "tcp" ] ; then
      # Sending TCP
      echo TAGA: $MYIP Sending $MSGCOUNT TCP Messages of $MSGLEN bytes to $target 
      iperf -c $target -n $MSGLEN -p $DESTPORT 
   else
      # Sending UDP
      echo TAGA: $MYIP Sending $MSGCOUNT UDP Messages of $MSGLEN bytes to $target 
      iperf -u -c $target -n $MSGLEN -p $DESTPORT 
   fi
}

#####################################
#####################################
# MAIN
#####################################
#####################################

#####################################
# Check Hostname 
#####################################
if $TAGA_CONFIG_DIR/hostList.sh | grep `hostname` >/dev/null ; then
  echo "My hostname: `hostname` is in the list of hosts - proceeding!" >/dev/null
else
  echo "My hostname: `hostname` is not in the list of hosts - exiting!"
  exit
fi

#####################################
# Validate the Configuration for this process
#####################################
#if [ $MSGRATE_CONFIGURED -ne 1 ] ; then
#   echo
#   echo TAGA NOTICE: Configured Message Rate \($MSGRATE_CONFIGURED\) is not supported.
#   echo TAGA NOTICE: Forcing Message Rate to One \(1\)
#   echo
#   #MSGRATE=1 # this var not actually used in this file
#   sleep 2
#fi
#

##########################################################
# Check if MCAST and start listener (join group) if MCAST
##########################################################
if [ $TESTTYPE == "MCAST" ]; then
   ####################################3
   # MCAST Receiver/Listener
   ####################################3
    # MCAST UDP
    # If MCAST, start the listener
    # prep the mgen config 
    # create the script from the template
    sed -e s/mcastgroup/$MYMCAST_ADDR/g $TAGA_MGEN_DIR/script_mcast_rcvr.mgn.template \
            > $TAGA_MGEN_DIR/script_mcast_rcvr.mgn 
    # run it, join the group
    if [ $TAGA_DISPLAY_SETTING -ge $TAGA_DISPLAY_ENUM_VAL_4_VERBOSE ]; then
      mgen input $TAGA_MGEN_DIR/script_mcast_rcvr.mgn &
    elif [ $TAGA_DISPLAY_SETTING -le $TAGA_DISPLAY_ENUM_VAL_1_SILENT ]; then
      mgen input $TAGA_MGEN_DIR/script_mcast_rcvr.mgn  >/dev/null 2> /dev/null &
    else
      mgen input $TAGA_MGEN_DIR/script_mcast_rcvr.mgn >/dev/null 2> /dev/null &
    fi
elif [ $TESTTYPE == "UCAST_TCP" ]; then
  echo NOTICE: TESTTYPE of UCAST_TCP is not supported by $0 - exiting!
  echo NOTICE: TESTTYPE of UCAST_TCP is not supported by $0 - exiting!
  echo NOTICE: Such Support May be added in the future
  echo NOTICE: Such Support May be added in the future
  echo NOTICE: Consider changing to MGEN TESTTYPE for TCP Tests
  echo NOTICE: Consider changing to MGEN TESTTYPE for TCP Tests
  echo NOTICE: TESTTYPE of UCAST_TCP is not supported by $0 - exiting!
  echo NOTICE: TESTTYPE of UCAST_TCP is not supported by $0 - exiting!
  exit
fi

#####################################
# Start the Server/Receiver
#####################################
# Set MYPORT
let i=0; let MYPORT=$PORTBASE

for target in $targetList
do let i=$i+1; if [ $target == $MYIP ]; then let MYPORT=$MYPORT+$i; fi ; done

echo TAGA: Starting IPERF Receiver on $MYIP

if [ $mgen_proto == "tcp" ] ; then
   # tcp
   iperf -s -p $MYPORT &
else
   # udp
   iperf -u -s -p $MYPORT &
fi

#####################################
# Traffi Generation Delay
#####################################
$tagaMgenDir/trafficDelay.sh $1 $2

# dlm temp , this above is no working, hard code it for now
sleep 10 

####################################
# Make Dummy File as Source
####################################
$tagaUtilsDir/makeFile.sh $MSGLEN

####################################
# Generate the Traffic!
####################################

####################################3
# MCAST Traffic
####################################3
if [ $TESTTYPE == "MCAST" ]; then
   let DESTPORT=$MYMCAST_PORT
   target=$MYMCAST_ADDR
   echo TAGA: $MYIP : Sending $MSGCOUNT packets of $MSGLEN bytes to $target port $DESTPORT
   let j=$MSGCOUNT
   while [ $j -gt 0 ] 
   do
      if [ $TAGA_DISPLAY_SETTING -ge $TAGA_DISPLAY_ENUM_VAL_4_VERBOSE ]; then
        echo TAGA: $MYIP : Sending $MSGLEN bytes to $target port $DESTPORT
      elif [ $TAGA_DISPLAY_SETTING -le $TAGA_DISPLAY_ENUM_VAL_1_SILENT ]; then
         echo TAGA: $MYIP : Sending $MSGLEN bytes to $target port $DESTPORT >/dev/null
      else
        echo TAGA: $MYIP : Sending $MSGLEN bytes to $target port $DESTPORT >/dev/null
      fi
      sendit >/dev/null 2>/dev/null
      sleep 1
      let j=$j-1
   done
   # MCAST - We are Done!
   exit
fi

####################################3
# UCAST Traffic
####################################3

# use the activated flag to stagger starts and ensure only one effective loop out of the two below
let activated=0
# init port-related vars
let i=0

###############################
# First Half of UCAST Loop
###############################
for target in $targetList
do
  
  let i=$i+1

  if [ $target == $MYIP ]; then
    #echo target is MYIP , skipping self... 
    let activated=1
    continue
  fi

  # use the activated flag to stagger starts and ensure only one effective loop out of the two loops
  # if not activated, continue to top
  if [ $activated -eq 0 ]; then
    continue
  fi

  let DESTPORT=$PORTBASE+$i

   echo TAGA: $MYIP : Sending $MSGCOUNT packets of $MSGLEN bytes to $target port $DESTPORT
   let j=$MSGCOUNT
   while [ $j -gt 0 ] 
   do
      if [ $TAGA_DISPLAY_SETTING -ge $TAGA_DISPLAY_ENUM_VAL_4_VERBOSE ]; then
        echo TAGA: $MYIP : Sending $MSGLEN bytes to $target port $DESTPORT
      elif [ $TAGA_DISPLAY_SETTING -le $TAGA_DISPLAY_ENUM_VAL_1_SILENT ]; then
         echo TAGA: $MYIP : Sending $MSGLEN bytes to $target port $DESTPORT >/dev/null
      else
        echo TAGA: $MYIP : Sending $MSGLEN bytes to $target port $DESTPORT >/dev/null
      fi
      sendit >/dev/null 2>/dev/null
      sleep 1
      let j=$j-1
   done
done

###############################
# Second Half of UCAST Loop
###############################
# reinit port-related vars
let i=0
# actiivated flag is okay

for target in $targetList
do
  
  let i=$i+1

  if [ $target == $MYIP ]; then
    #echo target is MYIP , skipping self... 
    let activated=0
    continue
  fi

  # use the activated flag to stagger starts and ensure only one effective loop out of the two loops
  # if not activated, continue to top
  if [ $activated -eq 0 ]; then
    continue
  fi

  let DESTPORT=$PORTBASE+$i

   echo TAGA: $MYIP : Sending $MSGCOUNT packets of $MSGLEN bytes to $target port $DESTPORT
   let j=$MSGCOUNT
   while [ $j -gt 0 ] 
   do
      if [ $TAGA_DISPLAY_SETTING -ge $TAGA_DISPLAY_ENUM_VAL_4_VERBOSE ]; then
        echo TAGA: $MYIP : Sending $MSGLEN bytes to $target port $DESTPORT
      elif [ $TAGA_DISPLAY_SETTING -le $TAGA_DISPLAY_ENUM_VAL_1_SILENT ]; then
         echo TAGA: $MYIP : Sending $MSGLEN bytes to $target port $DESTPORT >/dev/null
      else
        echo TAGA: $MYIP : Sending $MSGLEN bytes to $target port $DESTPORT >/dev/null
      fi
      sendit >/dev/null 2>/dev/null
      sleep 1
      let j=$j-1
   done

done

echo TAGA: TRAFFIC GENERATION COMPLETE on $MYIP
