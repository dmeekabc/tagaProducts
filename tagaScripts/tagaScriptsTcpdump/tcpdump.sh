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

if [ $TAGA_TRAFFIC_GENERATOR == "MGEN" ] ; then
  PORT_STR='port $SOURCEPORT'
  GREP_STR=''
elif [ $TAGA_TRAFFIC_GENERATOR == "IPERF" ] ; then
  PORT_STR='port $SOURCEPORT'
  GREP_STR=''
elif [ $TAGA_TRAFFIC_GENERATOR == "BASH" ] ; then
  PORT_STR=''
  GREP_STR='| grep $MSGLEN'
  GREP_STR=''
else
  # default
  PORT_STR='port $SOURCEPORT'
  GREP_STR=''
fi

#echo PORT_STR:$PORT_STR

NAME=`basename $0`
IPPART=`$iboaUtilsDir/iboa_padded_echo.sh $MYIP $IP_PAD_LEN`
NAMEPART=`$iboaUtilsDir/iboa_padded_echo.sh $NAME $NAME_PAD_LEN`
echo "$IPPART : $NAMEPART : executing at `date`"

# get the input 
MY_PARAM_IP=$1

# set the proto
if [ $TESTTYPE == "UCAST_TCP" ]; then myproto=tcp; else myproto=udp; fi

# add special handling for localhost
if [ $MYIP == "localhost" ] ; then
  MYINTERFACE="lo"
# add special handling for 192.168.1.2 node
elif [ $MYIP == "192.168.1.2" ] ; then
  MYINTERFACE="wlan0"
  MYINTERFACE="any"
else
  MYINTERFACE=`/sbin/ifconfig | grep $MY_PARAM_IP -B1 | head -n 1 | cut -d" " -f1`
fi

#echo MYINTERFACE:$MYINTERFACE

# if we are in the listener list, then listen for traffic
if $TAGA_CONFIG_DIR/hostList.sh | grep `hostname` >/dev/null ; then
  echo Running /usr/sbin/tcpdump on `hostname` > $STATUS_FILE 
  if [ $TAGA_DISPLAY_SETTING -ge $TAGA_DISPLAY_ENUM_VAL_4_VERBOSE ]; then
    /usr/bin/sudo /usr/sbin/tcpdump -n -s 200 -i $MYINTERFACE $myproto $PORT_STR -l $GREP_STR \
     <$TAGA_CONFIG_DIR/passwd.txt | tee                                                       \
     /tmp/$TEST_DESCRIPTION\_`hostname`_$MYINTERFACE\_$MY_PARAM_IP\_`date +%j%H%M%S` 
  else
    /usr/bin/sudo /usr/sbin/tcpdump -n -s 200 -i $MYINTERFACE $myproto $PORT_STR -l $GREP_STR \
     <$TAGA_CONFIG_DIR/passwd.txt >                                                           \
         /tmp/$TEST_DESCRIPTION\_`hostname`_$MYINTERFACE\_$MY_PARAM_IP\_`date +%j%H%M%S`      \
              2>/dev/null
  fi
else
  echo `hostname` is not in the list of Traffic/PLI Receivers | tee $STATUS_FILE 
  echo $0 Exiting with no action | tee $STATUS_FILE 
fi

