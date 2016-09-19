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
echo "$IPPART : $NAMEPART : executing at `date`"

#echo $0 executing at `date`
#echo $MYIP : `basename $0` : executing at `date`
#NAME=`basename $0`
#echo $MYIP : `basename $0` :  executing at `date`
#echo "`$iboaUtilsDir/iboa_padded_echo.sh $MYIP:..$NAME 30` : executing at `date`"
#echo "`$iboaUtilsDir/iboa_padded_echo.sh $MYIP:..$NAME $SCRIPT_HDR_PAD_LEN` : executing at `date`"

################################################3
# MAIN 
################################################3

SIM1_DIR=$TAGA_DIR/tagaSamples/sim1/python

# cleanup old processes, resources, sockets and such
OLDPROCFILE3="/home/$MYLOGIN_ID/python/python.pid"
rm $OLDPROCFILE3 2>/dev/null

if [ $MYIP == $DAEMON1_IP ]; then
   #echo $MYIP : `basename $0` : starting sim1 daemon1
   #echo "`$iboaUtilsDir/iboa_padded_echo.sh $MYIP:..$NAME 30` : starting SIM1 Daemon at `date`"
   CMDPART=`$iboaUtilsDir/iboa_padded_echo.sh Sim1Daemon $CMD_PAD_LEN`
   echo "$IPPART : $NAMEPART : starting $CMDPART at `date`"
   $SIM1_DIR/sim1.py start
elif [ $MYIP == $DAEMON2_IP ]; then
   #echo $MYIP : `basename $0` : starting sim1 daemon2
   #echo "`$iboaUtilsDir/iboa_padded_echo.sh $MYIP:..$NAME 30` : starting SIM1 Daemon at `date`"
   CMDPART=`$iboaUtilsDir/iboa_padded_echo.sh Sim1Daemon $CMD_PAD_LEN`
   echo "$IPPART : $NAMEPART : starting $CMDPART at `date`"
   $SIM1_DIR/sim1.py start
else
   #echo $MYIP : `basename $0` : starting sim1 daemonXXX
   #echo "`$iboaUtilsDir/iboa_padded_echo.sh $MYIP:..$NAME 30` : starting SIM1 Daemon at `date`"
   CMDPART=`$iboaUtilsDir/iboa_padded_echo.sh Sim1Daemon $CMD_PAD_LEN`
   echo "$IPPART : $NAMEPART : starting $CMDPART at `date`"
   $SIM1_DIR/sim1.py start
fi


