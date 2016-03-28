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


