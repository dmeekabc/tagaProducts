#!/bin/bash
#######################################################################
#
# Copyright (c) IBOA Corp 2017
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

TAGA_DIR=/cf/var/home/jtm
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

let VERBOSE=1
let VERBOSE=0

# continue to execute the command
echo $0 Proceeding.... at `date`; echo

for target in $targetList
do
   echo;echo
   echo ---------------------------------------------------------------------------
   echo `date` : TAGA: traceroute $target
   echo ---------------------------------------------------------------------------

   if [  $VERBOSE -eq 1 ] ; then
      ping -c 1 -W 5 $target
   else
      ping -c 1 -W 5 $target >/dev/null
   fi

   retCode=$?
   if [ $retCode -ne 0 ] ; then
      echo $target is not reachable, traceroute not performed
      echo Target:$target HopCount:Unavailable
   else
      #traceroute $target
#      traceroute $target
#      traceroute $target
#      traceroute $target
#      traceroute $target
#      traceroute $target
#      retCode=$?
#      echo retCode: $retCode
#      #echo
#      echo

      let hopCount=`traceroute $target | tail -n 1 | cut -c2-3`

#      let hopCount1=`traceroute $target | tail -n 1 | cut -c2-3`
#      sleep 10
#      let hopCount2=`traceroute $target | tail -n 1 | cut -c2-3`
#      sleep 10
#      let hopCount3=`traceroute $target | tail -n 1 | cut -c2-3`
#      sleep 10
#      let hopCount4=`traceroute $target | tail -n 1 | cut -c2-3`
#      sleep 10
#      let hopCount5=`traceroute $target | tail -n 1 | cut -c2-3`

#      let hopCountTotal=$hopCount1+$hopCount2+$hopCount3+$hopCount4+$hopCount5

      #let hopCountAverage=$hopCountTotal
#      let hopCountAverage=$hopCountTotal/5
#      echo hopCountTotal:$hopCountTotal
#      echo hopCountAverage:$hopCountAverage

#      echo Target:$target HopCount:$hopCount

      echo Target:$target HopCount:$hopCount

#      echo

   fi
done

echo
