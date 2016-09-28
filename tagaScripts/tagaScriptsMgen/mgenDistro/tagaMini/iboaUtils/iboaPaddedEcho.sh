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
source $TAGA_CONFIG_DIR/config
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


PADVAR=";"
PADVAR=";"
PADVAR=":"
PADVAR=" "
PADVAR="x"
PADVAR="."

if [ $# -ne 2 ]; then
   echo $0: Error, two params required!
   echo "   required param 1: output param to be padded"
   echo "   required param 2: size of output after padding"
   echo Your Param Count: $#
   if [ $# -eq 1 ] ; then
      echo Your Param 1: $1
   fi
   echo
   
   exit 255
fi

outputParam=$1
printlen=$2

buflen=`echo $outputParam | awk '{print length($0)}'`

let padlen=$printlen-$buflen
# add the padding
let i=$padlen
while [ $i -gt 0 ];
do
  outputParam="$outputParam$PADVAR"
  let i=$i-1
done

echo $outputParam




