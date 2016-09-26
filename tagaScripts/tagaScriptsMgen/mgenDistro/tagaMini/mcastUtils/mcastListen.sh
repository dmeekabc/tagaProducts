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
TAGA_DIR=/tmp/tagaMini
TAGA_DIR=~/tagaMini
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
TAGA_MGEN_DIR=$TAGA_DIR/mcastUtils
if [ -f $TAGA_CONFIG_DIR/config ]; then
  echo sourcing $TAGA_CONFIG_DIR/config
  source $TAGA_CONFIG_DIR/config
  # override the config for the path only
  TAGA_MGEN_DIR=$TAGA_DIR/mcastUtils
else
  echo sourcing ./mgenConfig
  source ./mgenConfig
fi

# Configure the listener
# Use the INTERFACE from the config or use default if none found
if [ $INTERFACE ] ; then
  ITFC=$INTERFACE
else
  ITFC=wlan0
fi

# Use the GROUP_PREFIX from the config or use default if none found
GROUP_PREFIX=`echo $MYMCAST_ADDR | cut -d\. -f 1`
GROUP_PREFIX=$MYMCAST_ADDR
if [ $GROUP_PREFIX ]; then
  echo got it > /dev/null
else
  # use 224 as default
  GROUP_PREFIX=224
fi

echo $0: "MYMCAST_ADDR: $MYMCAST_ADDR"
echo $0: "INTERFACE:    $INTERFACE"
echo $0: "GROUP_PREFIX: $GROUP_PREFIX"


# create the script from the template
sed -e s/mcastgroup/$MYMCAST_ADDR/g $TAGA_MGEN_DIR/scriptMcastReceiver.mgn.template \
   > $TAGA_MGEN_DIR/scriptMcastReceiver.mgn 

# start the mcast receiver in the backgrond (Join the Multicast Group)
/usr/bin/mgen input $TAGA_MGEN_DIR/scriptMcastReceiver.mgn &

# Listener Config
let TCPDUMP_NUMERIC_DISPLAY=0
let TCPDUMP_NUMERIC_DISPLAY=1

# listen for multicast traffic per the ITFC and GROUP_PREFIIX settings
if [ $TCPDUMP_NUMERIC_DISPLAY -eq 1 ]; then
   # listen with numeric option
   tcpdump -n -i $ITFC udp | grep $GROUP_PREFIX
else
   # listen without numeric option
   tcpdump -i $ITFC udp | grep $GROUP_PREFIX
fi

