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

let i=255

while [ $i -gt 225 ]
do
   NETADDR=$NETADDRPART.$i
   echo
   echo processing $NETADDR
   
   $TAGA_UTILS_DIR/probe2x.sh $NETADDR &

#   ping -W 1 -c 1 $NETADDR
#  
#   if [ $? -eq 0 ]; then
#      echo $NETADDR >> /tmp/probe2Found.out
#   else
#      echo $NETADDR >> /tmp/probe2Notfound.out
#   fi
#
   let i=$i-1

done

# this is expected to be the last processing script so do the sort now

# things have changed so forct it now
sleep 5


echo Found List:
cat /tmp/probe2Found.out | sort 
echo Not Found List:
cat /tmp/probe2Notfound.out | sort 
echo Found List:
cat /tmp/probe2Found.out | sort 

echo
echo Note: Any additional probe2.sh \(ping-related\) output below indicates the lists above are not complete!
echo Note: In that case, please examine /tmp/probe2Found.out and /tmp/probe2Notfound.out directly.
echo

for i in 1 2 3 4 5  
do
   sleep 2
   echo Found List:
   cat /tmp/probe2Found.out | sort 
   echo Not Found List:
   cat /tmp/probe2Notfound.out | sort 
   echo Found List:
   cat /tmp/probe2Found.out | sort 
done

echo
echo Note: Any additional probe2.sh \(ping-related\) output below indicates the lists above are not complete!
echo Note: In that case, please examine /tmp/probe2Found.out and /tmp/probe2Notfound.out directly.
echo

