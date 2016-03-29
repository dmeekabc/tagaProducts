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

#echo $MYIP : `basename $0` : executing at `date`
#NAME=`basename $0`
#echo $MYIP : `basename $0` :  executing at `date`
#echo "`$iboaUtilsDir/iboa_padded_echo.sh $MYIP:..$NAME 30` : executing at `date`"
#echo "`$iboaUtilsDir/iboa_padded_echo.sh $MYIP:..$NAME $SCRIPT_HDR_PAD_LEN` : executing at `date`"

# get the input 
MY_PARAM_IP=$1

# set the proto
if [ $TESTTYPE == "UCAST_TCP" ]; then
   myproto=tcp
else
   myproto=udp
fi

# add special handling for localhost
if [ $MYIP == "localhost" ] ; then
  MYINTERFACE="lo"
else
  MYINTERFACE=`ifconfig | grep $MY_PARAM_IP -B1 | head -n 1 | cut -d" " -f1`
fi

# if we are in the listener list, then listen for traffic
if $TAGA_CONFIG_DIR/hostList.sh | grep `hostname` >/dev/null ; then
  #echo Running tcpdump on `hostname` | tee $STATUS_FILE 
  echo Running tcpdump on `hostname` > $STATUS_FILE 
  if [ $TAGA_DISPLAY_SETTING -ge $TAGA_DISPLAY_ENUM_VAL_4_VERBOSE ]; then
  #if [ $TAGA_DISPLAY == "VERBOSE" ]; then
    tcpdump -n -s 200 -i $MYINTERFACE $myproto port $SOURCEPORT -l   \
     <$TAGA_CONFIG_DIR/passwd.txt | tee                             \
     /tmp/$TEST_DESCRIPTION\_`hostname`_$MYINTERFACE\_$MY_PARAM_IP\_`date +%j%H%M%S` 
  else
    tcpdump -n -s 200 -i $MYINTERFACE $myproto port $SOURCEPORT -l   \
     <$TAGA_CONFIG_DIR/passwd.txt > \
         /tmp/$TEST_DESCRIPTION\_`hostname`_$MYINTERFACE\_$MY_PARAM_IP\_`date +%j%H%M%S`  \
              2>/dev/null
  fi
else
  echo `hostname` is not in the list of Traffic/PLI Receivers | tee $STATUS_FILE 
  echo $0 Exiting with no action | tee $STATUS_FILE 
fi

