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

# Set and Source the TAGA CONFIG Dir
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

# add a capture group and myself to it
sudo groupadd mypcap
sudo usermod -a -G mypcap $MYLOGIN_ID

# next, change the group of tcpdump and set permissions
sudo chgrp mypcap /usr/sbin/tcpdump
sudo chmod 750 /usr/sbin/tcpdump

# finally, use setcap to give tcpdump the reqd permissions
sudo setcap cap_net_raw,cap_net_admin=eip /usr/sbin/tcpdump

cd /usr/sbin
sudo chmod 777 tcpdump

