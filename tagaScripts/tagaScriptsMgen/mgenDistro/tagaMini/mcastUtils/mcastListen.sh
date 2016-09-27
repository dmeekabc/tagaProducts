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
# Set the TAGA DIR BASE
if [ -d ~/scripts/tagaXXXXXXXXXX ]; then
  TAGA_DIR=~/scripts/taga # new mar 2016, relocateable
elif [ -d ~/tagaMini ]; then
  TAGA_DIR=~/tagaMini     # new sept 2016, tagaMini version
else
  TAGA_DIR=/tmp/tagaMini  # new sept 2016, tagaMini version
fi

# Set the TAGA CONFIG and MGEN Dirs
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
TAGA_MGEN_DIR=$TAGA_DIR/mcastUtils

# Use local mgenConfig as starting point, but override it below if configured elsewhere
echo sourcing ./mcastConfig
source $TAGA_MGEN_DIR/mcastConfig

# Use TAGA Config if found
if [ -f $TAGA_CONFIG_DIR/config ]; then
  echo sourcing $TAGA_CONFIG_DIR/config
  source $TAGA_CONFIG_DIR/config
  # override the config for the path only
  TAGA_MGEN_DIR=$TAGA_DIR/mcastUtils
fi

# Configure the listener
# Use the INTERFACE from the config or use default if none found
# Note: If loopback lo was found, use the default of wlan0
if [ $INTERFACE ] ; then
  if [ $INTERFACE != "lo" ]; then
     ITFC=$INTERFACE
  else
     ITFC=wlan0
  fi
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

# Finally, use forced params if provided
if [ $MYMCAST_ADDR_FORCE ] ; then
   MYMCAST_ADDR=$MYMCAST_ADDR_FORCE
fi
if [ $GROUP_PREFIX_FORCE ] ; then
   GROUP_PREFIX=$GROUP_PREFIX_FORCE
fi

echo
echo $0: "MYMCAST_ADDR:        $MYMCAST_ADDR"
echo $0: "LISTENING INTERFACE: $INTERFACE"
echo $0: "GROUP_PREFIX:        $GROUP_PREFIX"
echo

# Note: Additional Template-based configurations may be supported here in the future.
# Note: Additional Template-based configurations may be supported here in the future.

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
   sudo tcpdump -n -i $ITFC udp | grep $GROUP_PREFIX
else
   # listen without numeric option
   sudo tcpdump -i $ITFC udp | grep $GROUP_PREFIX
fi

