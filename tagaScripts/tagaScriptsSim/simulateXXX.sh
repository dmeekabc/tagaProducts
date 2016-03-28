#!/bin/bash

#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

NAME=`basename $0`
IPPART=`$iboaUtilsDir/iboa_padded_echo.sh $MYIP $IP_PAD_LEN`
NAMEPART=`$iboaUtilsDir/iboa_padded_echo.sh $NAME $NAME_PAD_LEN`
echo "$IPPART : $NAMEPART : executing at `date`"

#echo $MYIP : `basename $0` :  executing at `date`
#echo "`$iboaUtilsDir/iboa_padded_echo.sh $MYIP:..$NAME 30` : executing at `date`"
#echo "`$iboaUtilsDir/iboa_padded_echo.sh $MYIP:..$NAME $SCRIPT_HDR_PAD_LEN` : executing at `date`"

################################################3
# MAIN 
################################################3

XXX_DIR=$TAGA_DIR/tagaSamples/xxx/python

# cleanup old processes, resources, sockets and such
OLDPROCFILE3="/home/$MYLOGIN_ID/python/python.pid"
rm $OLDPROCFILE3 2>/dev/null

if [ $MYIP == "192.168.43.69" ]; then
   #echo $MYIP : `basename $0` : starting xxx daemon
   #echo "`$iboaUtilsDir/iboa_padded_echo.sh $MYIP:..$NAME 30` : starting XXXX Daemon at `date`"
   CMDPART=`$iboaUtilsDir/iboa_padded_echo.sh XXXXDaemon $CMD_PAD_LEN`
   echo "$IPPART : $NAMEPART : starting $CMDPART at `date`"
   $XXX_DIR/xxx.py start
elif [ $MYIP == "10.0.0.22" ]; then
   #echo $MYIP : `basename $0` : starting xxx daemon
   #echo "`$iboaUtilsDir/iboa_padded_echo.sh $MYIP:..$NAME 30` : starting XXXX Daemon at `date`"
   CMDPART=`$iboaUtilsDir/iboa_padded_echo.sh XXXXDaemon $CMD_PAD_LEN`
   echo "$IPPART : $NAMEPART : starting $CMDPART at `date`"
   $XXX_DIR/xxx.py start
else
   #echo $MYIP : `basename $0` : starting xxx daemon
   #echo "`$iboaUtilsDir/iboa_padded_echo.sh $MYIP:..$NAME 30` : starting XXXX Daemon at `date`"
   CMDPART=`$iboaUtilsDir/iboa_padded_echo.sh XXXXDaemon $CMD_PAD_LEN`
   echo "$IPPART : $NAMEPART : starting $CMDPART at `date`"
   $XXX_DIR/xxx.py start
fi

