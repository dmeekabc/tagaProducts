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

thistest=0
thistest=1
if [ $thistest -eq 1 ]; then 
   echo ------------  top `hostname` top $MYIP --------------------------
#   sleep 1
   top -b -n 1 | head -n 5
fi

thistest=1
thistest=0
if [ $thistest -eq 1 ]; then 
   echo ------------  ifconfig `hostname` ifconfig $MYIP --------------------------
#   sleep 1
   /sbin/ifconfig
fi

thistest=0
thistest=1
if [ $thistest -eq 1 ]; then 
   echo ------------  netstat -ns `hostname` netstat summary $MYIP --------------------------
#   sleep 1
   $tagaScriptsStatsDir/netstatSum.sh
   #$TAGA_DIR/netstatSum.sh
fi

thistest=1
thistest=0
if [ $thistest -eq 1 ]; then 
   echo ------------  netstat -ns `hostname` netstat -ns $MYIP --------------------------
#   sleep 1
   netstat -ns
fi

thistest=1
thistest=0
if [ $thistest -eq 1 ]; then 
   echo ------------  netstat -r  \(route\) `hostname` $MYIP ---------------------
#   sleep 1
   netstat -r
fi

