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
if [ $INTERFACE ] ; then
  ITFC=$INTERFACE
else
  ITFC=wlan0
fi

echo
echo $0: "MYMCAST_ADDR:      $MYMCAST_ADDR"
echo $0: "SENDING INTERFACE: Unspecified"
echo

# create the script from the template
sed -e s/mcastgroup/$MYMCAST_ADDR/g \
   $TAGA_MGEN_DIR/scriptMcastSender.mgn.template \
   > $TAGA_MGEN_DIR/scriptMcastSender.mgn 

# start the mcast sender 
/usr/bin/mgen input $TAGA_MGEN_DIR/scriptMcastSender.mgn 

