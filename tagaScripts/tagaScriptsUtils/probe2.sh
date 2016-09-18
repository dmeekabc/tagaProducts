#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################
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

# reinit the files
rm /tmp/probe2Found.out    2>/dev/null
rm /tmp/probe2Notfound.out 2>/dev/null


$TAGA_UTILS_DIR/probe2a.sh &
$TAGA_UTILS_DIR/probe2a2.sh &
$TAGA_UTILS_DIR/probe2b.sh &
$TAGA_UTILS_DIR/probe2b2.sh &
$TAGA_UTILS_DIR/probe2c.sh &
$TAGA_UTILS_DIR/probe2c2.sh &
$TAGA_UTILS_DIR/probe2d.sh &
$TAGA_UTILS_DIR/probe2d2.sh &
$TAGA_UTILS_DIR/probe2e.sh &    # this is the one with the output
$TAGA_UTILS_DIR/probe2e2.sh &


exit

let i=255

while [ $i -gt 0 ]
do
   NETADDR=$NETADDRPART.$i
   echo
   echo processing $NETADDR
   
   sudo ping -W 1 -c 1 $NETADDR
  
   if [ $? -eq 0 ]; then
      echo $NETADDR >> /tmp/probe2Found.out
   else
      echo $NETADDR >> /tmp/probe2Notfound.out
   fi

   let i=$i-1

done

echo




