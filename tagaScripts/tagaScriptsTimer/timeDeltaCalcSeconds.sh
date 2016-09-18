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

# get the input which provides multi-task support
#   ... that is as long as the calling folks pass a param as expected!


if [ $# -eq 0 ] ; then
  echo WARNING: Calling this $0 script without a parameter is acceptable but it is not thread safe.
fi


if [ -f /tmp/markSecs1.$1.dat ] ; then
   date +%s > /tmp/markSecs2.$1.dat
   let START=`cat /tmp/markSecs1.$1.dat`
   let END=`cat /tmp/markSecs2.$1.dat`
   let DELTA=$END-$START
   echo $DELTA seconds
   rm /tmp/markSecs1.$1.dat
   rm /tmp/markSecs2.$1.dat
else
   date +%s > /tmp/markSecs1.$1.dat
fi

