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

NAME=`basename $0`
IPPART=`$iboaUtilsDir/iboa_padded_echo.sh $MYIP $IP_PAD_LEN`
NAMEPART=`$iboaUtilsDir/iboa_padded_echo.sh $NAME $NAME_PAD_LEN`

if [ $VAR_TEST_ENABLED == 1 ]; then
  if [ $TAGA_DISPLAY_SETTING -ge $TAGA_DISPLAY_ENUM_VAL_4_VERBOSE ]; then
    echo "$IPPART : $NAMEPART : executing at `date`"
  fi
#  echo `basename $0` End of Cycle Tests 1 Enabled - proceeding...
else
  if [ $TAGA_DISPLAY_SETTING -ge $TAGA_DISPLAY_ENUM_VAL_4_VERBOSE ]; then
    echo "$IPPART : $NAMEPART : disabled at `date`"
  fi

#  echo `basename $0` End of Cycle Tests 1 Disabled - Exiting
  exit
fi

#echo `date` : $MYIP : `basename $0` : Executing...
#echo `date` : $MYIP : `basename $0` : Exiting...
