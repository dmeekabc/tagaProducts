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

if [ $MYIP == "localhost" ]; then
  echo WARNING: MYIP == localhost
  echo WARNING: MYIP == localhost, check configuration, check config_extensions!!
  echo WARNING: MYIP == localhost, check configuration, check config_extensions!!
  echo WARNING: MYIP == localhost
  /sbin/ifconfig
  echo WARNING: MYIP == localhost
  echo WARNING: MYIP == localhost, check configuration, check config_extensions!!
  echo WARNING: MYIP == localhost, check configuration, check config_extensions!!
  echo WARNING: MYIP == localhost
fi

NAME=`basename $0`
IPPART=`$iboaUtilsDir/iboa_padded_echo.sh $MYIP $IP_PAD_LEN`
NAMEPART=`$iboaUtilsDir/iboa_padded_echo.sh $NAME $NAME_PAD_LEN`
echo "$IPPART : $NAMEPART : executing at `date`"

# get the INTERFACE to use, note my IP is in $1 which is used to find INTERFACE
if [ $# -ge 1 ] ; then
  INTERFACE=`/sbin/ifconfig | grep $1 -B1 | head -n 1 | cut -d" " -f1`
else
  INTERFACE=`/sbin/ifconfig | grep $MYIP -B1 | head -n 1 | cut -d" " -f1`
fi


# default to UDP, this should be overriden by config
mgen_proto=UDP

###############################
# Init Part
###############################

# Set MYPORT
let i=0
let MYPORT=$PORTBASE
for target in $targetList
do
  let i=$i+1
  if [ $target == $MYIP ]; then
    let MYPORT=$MYPORT+$i
  fi 
done

###############################
# Server (Traffic Receiver) Part
###############################

# Start Server

echo TAGA: $MYIP : Starting MGEN Server / Receiver

if $TAGA_CONFIG_DIR/hostList.sh | grep `hostname` >/dev/null ; then
  if [ $TESTTYPE == "MCAST" ]; then
    # MCAST UDP
    # prep the mgen config 
    # create the script from the template
    sed -e s/mcastgroup/$MYMCAST_ADDR/g $TAGA_MGEN_DIR/script_mcast_rcvr.mgn.template \
            > $TAGA_MGEN_DIR/script_mcast_rcvr.mgn 
    # run it, joing the group
    if [ $TAGA_DISPLAY_SETTING -ge $TAGA_DISPLAY_ENUM_VAL_4_VERBOSE ]; then
      #mgen input $TAGA_MGEN_DIR/script_mcast_rcvr.mgn #&
      mgen input $TAGA_MGEN_DIR/script_mcast_rcvr.mgn &
    elif [ $TAGA_DISPLAY_SETTING -le $TAGA_DISPLAY_ENUM_VAL_1_SILENT ]; then
      #mgen input $TAGA_MGEN_DIR/script_mcast_rcvr.mgn  >/dev/null 2> /dev/null #&
      mgen input $TAGA_MGEN_DIR/script_mcast_rcvr.mgn  >/dev/null 2> /dev/null &
    else
      #mgen input $TAGA_MGEN_DIR/script_mcast_rcvr.mgn >/dev/null #&
      mgen input $TAGA_MGEN_DIR/script_mcast_rcvr.mgn >/dev/null &
    fi

    # start the UDP listener in background
  elif [ $TESTTYPE == "UCAST_TCP" ]; then
    # UCAST TCP
    # override mgen_proto default value of UDP  
    mgen_proto=TCP
    # prep the mgen config 
    # create the script from the template
    sed -e s/port/$MYPORT/g $TAGA_MGEN_DIR/script_tcp_listener.mgn.template \
            > $TAGA_MGEN_DIR/script_tcp_listener.mgn  
    # start the TCP listener in background
    if [ $TAGA_DISPLAY_SETTING -ge $TAGA_DISPLAY_ENUM_VAL_4_VERBOSE ]; then
      mgen input $TAGA_MGEN_DIR/script_tcp_listener.mgn & 
    elif [ $TAGA_DISPLAY_SETTING -le $TAGA_DISPLAY_ENUM_VAL_1_SILENT ]; then
      mgen input $TAGA_MGEN_DIR/script_tcp_listener.mgn > /dev/null 2> /dev/null & 
    else
      mgen input $TAGA_MGEN_DIR/script_tcp_listener.mgn > /dev/null & 
    fi
  else
    # UCAST UDP
    # start the UDP listener in background
    if [ $TAGA_DISPLAY_SETTING -ge $TAGA_DISPLAY_ENUM_VAL_4_VERBOSE ]; then
      mgen port $MYPORT & 
    elif [ $TAGA_DISPLAY_SETTING -le $TAGA_DISPLAY_ENUM_VAL_1_SILENT ]; then
      mgen port $MYPORT > /dev/null 2>/dev/null & 
    else
      mgen port $MYPORT > /dev/null  & 
    fi
  fi
else
  echo `hostname` is not in the list of Traffic/PLI Receivers | tee $STATUS_FILE
  echo $0 Exiting with no action | tee $STATUS_FILE
  exit
fi

#sleep $SERVER_INIT_DELAY
let CURRENT_EPOCH=`date +%s`

# determine the time to start sending traffic (set wait time accorrdingly)
if [ $# -ge 2 ] ; then
   # we have a start time parameter, get it and calc wait time...
   let TRAFFIC_START_EPOCH=$2
   let WAITTIME=$TRAFFIC_START_EPOCH-$CURRENT_EPOCH
else
   # if we have no start time param, start immediately (set wait time to 0)
   let WAITTIME=0
fi

# round to nearest 5
# note, this rounding impacts the "traffic start synch"
# note that this round time becomes a: 
#    "closest ensured traffic start time synch"
# note, 
let ROUND_TIME=1
let ROUND_TIME=5
let WAITTIME=$WAITTIME/$ROUND_TIME
let WAITTIME=$WAITTIME*$ROUND_TIME
let WAITTIME=$WAITTIME+$ROUND_TIME

# if wait time exceeds, max allowed, set it to the max wait time allowed
MAX_WAIT_TIME=40
MAX_WAIT_TIME=80
MAX_WAIT_TIME=120
MAX_WAIT_TIME=10
if [ $WAITTIME -gt $MAX_WAIT_TIME ]; then
  let WAITTIME=MAX_WAIT_TIME
fi

# ensure non-negative wait time
if [ $WAITTIME -lt 0 ]; then
   echo
   echo Warning: $0: negatie WAITTIME: $WAITTIME
   echo Warning: $0: negatie WAITTIME: $WAITTIME
   echo Warning: Bad SUDO, SSH, bad time synch, bad config, etc can cause delays , this condition.
   echo Warning: Bad SUDO, SSH, bad time synch, bad config, etc can cause delays , this condition.
   echo Warning: Consider increasing MGEN_SERVER_INIT_DELAY
   echo Warning: Consider increasing MGEN_SERVER_INIT_DELAY
   echo
   # something is wrong, wait max amount of time
   let WAITTIME=MAX_WAIT_TIME
fi

if [ $WAITTIME -gt 0 ]; then

   #echo TAGA: $MYIP : Waiting $WAITTIME seconds to Start MGEN Sender...

   if [ $TAGA_DISPLAY_SETTING -ge $TAGA_DISPLAY_ENUM_VAL_4_VERBOSE ]; then
#     echo  waiting:$WAITTIME
      sleep $WAITTIME
     #$TAGA_UTILS_DIR/tagaDelay.sh $WAITTIME
#     echo done waiting:$WAITTIME
   elif [ $TAGA_DISPLAY_DEBUG -eq 1 ]; then
#     echo  waiting:$WAITTIME
      sleep $WAITTIME
     #$TAGA_UTILS_DIR/tagaDelay.sh $WAITTIME
#     echo done waiting:$WAITTIME
   else
     #sleep $WAITTIME
#     echo  waiting:$WAITTIME
      sleep $WAITTIME
     #$TAGA_UTILS_DIR/tagaDelay.sh $WAITTIME
#     echo Done waiting:$WAITTIME seconds
     #echo TAGA: Starting mgen Receiver...
#     echo TAGA: Starting mgen Sender...
   fi

   #echo TAGA: $MYIP : DONE Waiting $WAITTIME seconds to Start MGEN Sender...
   #echo TAGA: $MYIP : Starting MGEN Sender...
   echo TAGA: $MYIP : Wait Complete: $WAITTIME sec waited: Starting MGEN Sender...

fi


###############################
# Traffic Generation (Client) Part
###############################

# reinit port-related vars
let i=0

# Start Traffic to other Nodes

# use the activated flag to stagger starts and ensure only one effective loop out of the two below
let activated=0

###############################
# MCAST processing (if testtype == MCAST)
###############################

if [ $TESTTYPE == "MCAST" ]; then

  if echo $MCAST_SENDER_FILTER_LIST | grep $MYIP >/dev/null; then
    echo $MYIP is in the MCAST SENDER LIST, starting mcast sender
  else
    echo $MYIP is not in the MCAST SENDER LIST, _not_ starting mcast sender!
    exit
  fi
  
  let i=$i+1

  let DESTPORT=$MYMCAST_PORT
  target=$MYMCAST_ADDR

  TEMPFILE=$TAGA_MGEN_DIR/script.$INTERFACE.mgn.temp  
  TEMP2FILE=$TAGA_MGEN_DIR/script.$INTERFACE.mgn.temp2  
  SCRIPTFILE=$TAGA_MGEN_DIR/script.$INTERFACE.mgn
  
  # prep the mgen config 
  sed -e s/destination/$target/g $TAGA_MGEN_DIR/script.mgn.template > $TEMPFILE  # create temp from template
  sed -e s/destport/$DESTPORT/g $TEMPFILE                           > $TEMP2FILE # toggle temp/temp2
  sed -e s/sourceport/$SOURCEPORT/g $TEMP2FILE                      > $TEMPFILE  # toggle temp/temp2
  sed -e s/count/$MSGCOUNT/g $TEMPFILE                              > $TEMP2FILE # toggle temp/temp2
  sed -e s/rate/$MSGRATE/g $TEMP2FILE                               > $TEMPFILE  # toggle temp/temp2
  sed -e s/proto/$mgen_proto/g $TEMPFILE                            > $TEMP2FILE # toggle temp/temp2
  sed -e s/interface/$INTERFACE/g $TEMP2FILE                        > $TEMPFILE  # toggle temp/temp2
  sed -e s/len/$MSGLEN/g $TEMPFILE                                  > $SCRIPTFILE       # finalize

  # make sure we want to specify the interface
  if [ $INTERFACE_SPECIFIED_SOURCE -eq 1 ]; then
    echo okay, no change needed >/dev/null
  else
    echo okay, we need to prune the interface info from the script file >/dev/null
    sed -e s/INTERFACE//g $SCRIPTFILE  > $TEMPFILE # create temp from script file
    sed -e s/$INTERFACE//g $TEMPFILE > $SCRIPTFILE  # finalize again
  fi

  # some cleanup
  rm $TEMPFILE ; rm $TEMP2FILE

  #if [ $TAGA_DISPLAY == "VERBOSE" ]; then
  if [ $TAGA_DISPLAY_SETTING -ge $TAGA_DISPLAY_ENUM_VAL_4_VERBOSE ]; then
    echo ---------------------
    cat $SCRIPTFILE
    echo ---------------------
    mgen input $SCRIPTFILE 
  #elif [ $TAGA_DISPLAY == "SILENT" ]; then
  elif [ $TAGA_DISPLAY_SETTING -le $TAGA_DISPLAY_ENUM_VAL_1_SILENT ]; then
    mgen input $SCRIPTFILE  > /dev/null 2> /dev/null
  else
    mgen input $SCRIPTFILE  #>/dev/null
  fi
  
  # MCAST - we are done, exit the script
  echo TAGA: TRAFFIC GENERATION COMPLETE on $MYIP
  exit

fi # if multicast flag is true


###############################
# UCAST processing (if testtype == UCAST)
###############################

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

  TEMPFILE=$TAGA_MGEN_DIR/script.$INTERFACE.mgn.temp  
  TEMP2FILE=$TAGA_MGEN_DIR/script.$INTERFACE.mgn.temp2  
  SCRIPTFILE=$TAGA_MGEN_DIR/script.$INTERFACE.mgn

  # prep the mgen config 
#  sed -e s/destination/$target/g $TAGA_MGEN_DIR/script.mgn.template > $TAGA_MGEN_DIR/script.mgn.temp  # create temp from template
#  sed -e s/destport/$DESTPORT/g $TAGA_MGEN_DIR/script.mgn.temp      > $TAGA_MGEN_DIR/script.mgn.temp2 # toggle temp/temp2
#  sed -e s/sourceport/$SOURCEPORT/g $TAGA_MGEN_DIR/script.mgn.temp2 > $TAGA_MGEN_DIR/script.mgn.temp  # toggle temp/temp2
#  sed -e s/count/$MSGCOUNT/g $TAGA_MGEN_DIR/script.mgn.temp         > $TAGA_MGEN_DIR/script.mgn.temp2 # toggle temp/temp2
#  sed -e s/rate/$MSGRATE/g $TAGA_MGEN_DIR/script.mgn.temp2          > $TAGA_MGEN_DIR/script.mgn.temp  # toggle temp/temp2
#  sed -e s/proto/$mgen_proto/g $TAGA_MGEN_DIR/script.mgn.temp       > $TAGA_MGEN_DIR/script.mgn.temp2 # toggle temp/temp2
#  sed -e s/interface/$INTERFACE/g $TAGA_MGEN_DIR/script.mgn.temp2   > $TAGA_MGEN_DIR/script.mgn.temp  # toggle temp/temp2
#  sed -e s/len/$MSGLEN/g $TAGA_MGEN_DIR/script.mgn.temp             > $TAGA_MGEN_DIR/script.$INTERFACE.mgn       # finalize

  # prep the mgen config 
  sed -e s/destination/$target/g $TAGA_MGEN_DIR/script.mgn.template > $TEMPFILE  # create temp from template
  sed -e s/destport/$DESTPORT/g $TEMPFILE                           > $TEMP2FILE # toggle temp/temp2
  sed -e s/sourceport/$SOURCEPORT/g $TEMP2FILE                      > $TEMPFILE  # toggle temp/temp2
  sed -e s/count/$MSGCOUNT/g $TEMPFILE                              > $TEMP2FILE # toggle temp/temp2
  sed -e s/rate/$MSGRATE/g $TEMP2FILE                               > $TEMPFILE  # toggle temp/temp2
  sed -e s/proto/$mgen_proto/g $TEMPFILE                            > $TEMP2FILE # toggle temp/temp2
  sed -e s/interface/$INTERFACE/g $TEMP2FILE                        > $TEMPFILE  # toggle temp/temp2
  sed -e s/len/$MSGLEN/g $TEMPFILE                                  > $SCRIPTFILE       # finalize

  # make sure we want to specify the interface
  if [ $INTERFACE_SPECIFIED_SOURCE -eq 1 ]; then
    echo okay, no change needed >/dev/null
  else
    echo okay, we need to prune the interface info from the script file >/dev/null
    sed -e s/INTERFACE//g $SCRIPTFILE  > $TEMPFILE # create temp from script file
    sed -e s/$INTERFACE//g $TEMPFILE > $SCRIPTFILE  # finalize again
  fi

  if [ $TESTTYPE == "UCAST_TCP" ]; then
     let tcpDelay=$MSGCOUNT/$MSGRATE
     let tcpDelay=$tcpDelay+1
     echo $tcpDelay.0 OFF 1 >> $SCRIPTFILE      # append TCP specific stuff
  fi

  # some cleanup
  rm $TEMPFILE ; rm $TEMP2FILE

  #if [ $TAGA_DISPLAY == "VERBOSE" ]; then
  if [ $TAGA_DISPLAY_SETTING -ge $TAGA_DISPLAY_ENUM_VAL_4_VERBOSE ]; then
    echo ---------------------
    cat $SCRIPTFILE 
    echo ---------------------
    mgen input $SCRIPTFILE 
  elif [ $TAGA_DISPLAY_SETTING -le $TAGA_DISPLAY_ENUM_VAL_1_SILENT ]; then
  #elif [ $TAGA_DISPLAY == "SILENT" ]; then
    mgen input $SCRIPTFILE  > /dev/null 2> /dev/null
  else
    mgen input $SCRIPTFILE  # >/dev/null
  fi
  

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

  TEMPFILE=$TAGA_MGEN_DIR/script.$INTERFACE.mgn.temp  
  TEMP2FILE=$TAGA_MGEN_DIR/script.$INTERFACE.mgn.temp2  
  SCRIPTFILE=$TAGA_MGEN_DIR/script.$INTERFACE.mgn
  
  # prep the mgen config 
#  sed -e s/destination/$target/g $TAGA_MGEN_DIR/script.mgn.template > $TAGA_MGEN_DIR/script.mgn.temp  # create temp from template
#  sed -e s/destport/$DESTPORT/g $TAGA_MGEN_DIR/script.mgn.temp      > $TAGA_MGEN_DIR/script.mgn.temp2 # toggle temp/temp2
#  sed -e s/sourceport/$SOURCEPORT/g $TAGA_MGEN_DIR/script.mgn.temp2 > $TAGA_MGEN_DIR/script.mgn.temp  # toggle temp/temp2
#  sed -e s/count/$MSGCOUNT/g $TAGA_MGEN_DIR/script.mgn.temp         > $TAGA_MGEN_DIR/script.mgn.temp2 # toggle temp/temp2
#  sed -e s/rate/$MSGRATE/g $TAGA_MGEN_DIR/script.mgn.temp2          > $TAGA_MGEN_DIR/script.mgn.temp  # toggle temp/temp2
#  sed -e s/proto/$mgen_proto/g $TAGA_MGEN_DIR/script.mgn.temp       > $TAGA_MGEN_DIR/script.mgn.temp2 # toggle temp/temp2
#  sed -e s/interface/$INTERFACE/g $TAGA_MGEN_DIR/script.mgn.temp2   > $TAGA_MGEN_DIR/script.mgn.temp  # toggle temp/temp2
#  sed -e s/len/$MSGLEN/g $TAGA_MGEN_DIR/script.mgn.temp             > $TAGA_MGEN_DIR/script.$INTERFACE.mgn       # finalize

  # prep the mgen config 
  sed -e s/destination/$target/g $TAGA_MGEN_DIR/script.mgn.template > $TEMPFILE  # create temp from template
  sed -e s/destport/$DESTPORT/g $TEMPFILE                           > $TEMP2FILE # toggle temp/temp2
  sed -e s/sourceport/$SOURCEPORT/g $TEMP2FILE                      > $TEMPFILE  # toggle temp/temp2
  sed -e s/count/$MSGCOUNT/g $TEMPFILE                              > $TEMP2FILE # toggle temp/temp2
  sed -e s/rate/$MSGRATE/g $TEMP2FILE                               > $TEMPFILE  # toggle temp/temp2
  sed -e s/proto/$mgen_proto/g $TEMPFILE                            > $TEMP2FILE # toggle temp/temp2
  sed -e s/interface/$INTERFACE/g $TEMP2FILE                        > $TEMPFILE  # toggle temp/temp2
  sed -e s/len/$MSGLEN/g $TEMPFILE                                  > $SCRIPTFILE       # finalize

  # make sure we want to specify the interface
  if [ $INTERFACE_SPECIFIED_SOURCE -eq 1 ]; then
    echo okay, no change needed >/dev/null
  else
    echo okay, we need to prune the interface info from the script file >/dev/null
    sed -e s/INTERFACE//g $SCRIPTFILE  > $TEMPFILE # create temp from script file
    sed -e s/$INTERFACE//g $TEMPFILE > $SCRIPTFILE  # finalize again
  fi

  if [ $TESTTYPE == "UCAST_TCP" ]; then
     let tcpDelay=$MSGCOUNT/$MSGRATE
     let tcpDelay=$tcpDelay+1
     echo $tcpDelay.0 OFF 1 >> $SCRIPTFILE       # append TCP specific stuff
  fi

  # some cleanup
  rm $TEMPFILE ; rm $TEMP2FILE

  #if [ $TAGA_DISPLAY == "VERBOSE" ]; then
  if [ $TAGA_DISPLAY_SETTING -ge $TAGA_DISPLAY_ENUM_VAL_4_VERBOSE ]; then
    echo ---------------------
    cat $SCRIPTFILE 
    echo ---------------------
    mgen input $SCRIPTFILE 
  elif [ $TAGA_DISPLAY_SETTING -le $TAGA_DISPLAY_ENUM_VAL_1_SILENT ]; then
  #elif [ $TAGA_DISPLAY == "SILENT" ]; then
    mgen input $SCRIPTFILE  > /dev/null 2> /dev/null
  else
    mgen input $SCRIPTFILE  # >/dev/null
  fi

done

echo TAGA: TRAFFIC GENERATION COMPLETE on $MYIP


# IPERF examples
#--------------------------------------------------
#echo Running iperf on `hostname` | tee $STATUS_FILE
#sudo iperf -s -u -B 225.0.0.57 -i 10
#echo "sudo iperf -s -u -B $MYMCAST_ADDR -i 10"
#sudo iperf -s -u -B $MYMCAST_ADDR -i 10

# IPERF examples
#--------------------------------------------------
#echo Running iperf on `hostname` | tee $STATUS_FILE
#sudo iperf -s -u -B 225.0.0.57 -i 10
#echo "sudo iperf -s -u -B $MYMCAST_ADDR -i 10"
#sudo iperf -s -u -B $MYMCAST_ADDR -i 10

