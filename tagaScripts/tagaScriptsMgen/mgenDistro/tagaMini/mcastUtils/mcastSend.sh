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


# Note: INTERFACE config is preserved to allow specification of the Sending INTERFACE in future

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

# Finally, use forced params if provided
if [ $MYMCAST_ADDR_FORCE ] ; then
   MYMCAST_ADDR=$MYMCAST_ADDR_FORCE
fi

echo
echo $0: "MYMCAST_ADDR:      $MYMCAST_ADDR"
echo $0: "SENDING INTERFACE: Unspecified (ok)"
echo

# Note: Additional Template-based configurations may be supported here in the future.
# Note: Additional Template-based configurations may be supported here in the future.
  ## prep the mgen config 
  #sed -e s/destination/$target/g $TAGA_MGEN_DIR/script.mgn.template > $TEMPFILE  # create temp from template
  #sed -e s/destport/$DESTPORT/g $TEMPFILE                           > $TEMP2FILE # toggle temp/temp2
  #sed -e s/sourceport/$SOURCEPORT/g $TEMP2FILE                      > $TEMPFILE  # toggle temp/temp2
  #sed -e s/count/$MSGCOUNT/g $TEMPFILE                              > $TEMP2FILE # toggle temp/temp2
  #sed -e s/rate/$MSGRATE/g $TEMP2FILE                               > $TEMPFILE  # toggle temp/temp2
  #sed -e s/proto/$mgen_proto/g $TEMPFILE                            > $TEMP2FILE # toggle temp/temp2
  #sed -e s/interface/$INTERFACE/g $TEMP2FILE                        > $TEMPFILE  # toggle temp/temp2
  #sed -e s/len/$MSGLEN/g $TEMPFILE                                  > $SCRIPTFILE       # finalize


# create the script from the template
sed -e s/mcastgroup/$MYMCAST_ADDR/g \
   $TAGA_MGEN_DIR/scriptMcastSender.mgn.template \
   > $TAGA_MGEN_DIR/scriptMcastSender.mgn 

echo
echo "$0: MCAST Traffic to Group: $MYMCAST_ADDR will begin shortly..."
echo

# start the mcast sender 
/usr/bin/mgen input $TAGA_MGEN_DIR/scriptMcastSender.mgn 

