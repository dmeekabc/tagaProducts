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

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

let DEBUG=0
let DEBUG=1

#SPLIT_FILE=/tmp/tagaSplitFile.out

echo; echo $0 : $MYIP :  executing at `date`; echo

#################################################
# REMOTE FUNCTION
#################################################

function remoteFunction 
{
   target=$1
   for oid in `cat $SPLIT_FILE.$target`
   do
      SEARCH_OID=$oid
      oidDescription=`snmptranslate -mall -Tl $SEARCH_OID 2>/dev/null` 
      value=`snmpget -v 3 -t 60 -u demo -l authPriv -a MD5 -A raspsnmp -x DES -X raspsnmp $MYIP $oidDescription | cut -d= -f 2 | cut -d: -f 2`
      echo "`$tagaUtilsDir/iboaPaddedEcho.sh $oidDescription 40` : `$tagaUtilsDir/iboaPaddedEcho.sh $oid 26` : $value"
   done
}


##################################################################
# DO IT - do the remote function (passing MYIP as input param)
##################################################################
#remoteFunction $MYIP > $SPLIT_FILE.$MYIP.out
remoteFunction $MYIP | tee $SPLIT_FILE.$MYIP.out

