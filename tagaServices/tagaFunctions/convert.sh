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

VERBOSE=0
VERBOSE=1

if [ $VERBOSE -eq 1 ] ; then
   echo; echo $0 : $MYIP :  executing at `date`; echo
   echo Converting $1 bytes per second to Kbps
fi

let bitsPerSec=$1*8

if [ $VERBOSE -eq 1 ] ; then
echo $bitsPerSec bps
fi

# dlm temp , this is initial implementation, for now just round off to Kbps integer 
# without decimal points, plan is to add decimal point support in near future
let kiloBitsPerSec=$bitsPerSec/1000

if [ $VERBOSE -eq 1 ] ; then
echo $kiloBitsPerSec Kbps
fi

   # dlm temp test only, remove me
   # dlm temp test only, remove me
   # dlm temp test only, remove me
   # dlm temp test only, remove me
   # dlm temp test only, remove me
   let kiloBitsPerSec=$bitsPerSec
   # dlm temp test only, remove me
   # dlm temp test only, remove me
   # dlm temp test only, remove me
   # dlm temp test only, remove me

   wordlen=`echo $kiloBitsPerSec | awk '{print length($0)}'`

   if [ $wordlen -eq 8 ]; then
      let MBytes=$kiloBitsPerSec*10 # multiply by 10 to get fraction
      let MBytes=$MBytes/1000000
      megabitPrint=`echo $MBytes | cut -c1-2`.`echo $MBytes | cut -c3`
      #echo "kiloBitsPerSec: $kiloBitsPerSec ($megabitPrint Mbps)" > /dev/null
   elif [ $wordlen -eq 7 ]; then
      let MBytes=$kiloBitsPerSec*10 # multiply by 10 to get fraction
      let MBytes=$MBytes/1000000
      megabitPrint=`echo $MBytes | cut -c1`.`echo $MBytes | cut -c2`
      #echo "kiloBitsPerSec: $kiloBitsPerSec ($megabitPrint Mbps)" > /dev/null
   elif [ $wordlen -eq 6 ]; then
      let KBytes=$kiloBitsPerSec*10 # multiply by 10 to get fraction
      let KBytes=$KBytes/1000
      kilobitPrint=`echo $KBytes | cut -c1-3`.`echo $KBytes | cut -c4`
      #echo "kiloBitsPerSec: $kiloBitsPerSec ($kilobitPrint Kbps)" > /dev/null
   elif [ $wordlen -eq 5 ]; then
      let KBytes=$kiloBitsPerSec*10 # multiply by 10 to get fraction
      let KBytes=$KBytes/1000
      kilobitPrint=`echo $KBytes | cut -c1-2`.`echo $KBytes | cut -c3-4`
      #echo "kiloBitsPerSec: $kiloBitsPerSec ($kilobitPrint Kbps)" > /dev/null
   elif [ $wordlen -eq 4 ]; then
      let KBytes=$kiloBitsPerSec*10 # multiply by 10 to get fraction
      let KBytes=$KBytes/1000
      kilobitPrint=`echo $KBytes | cut -c1`.`echo $KBytes | cut -c2-4`
      #echo "kiloBitsPerSec: $kiloBitsPerSec ($kilobitPrint Kbps)" > /dev/null
   else
      echo "kiloBitsPerSec: $kiloBitsPerSec" > /dev/null
   fi

echo $kilobitPrint





