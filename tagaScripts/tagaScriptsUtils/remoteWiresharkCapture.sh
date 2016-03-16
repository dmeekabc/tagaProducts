#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

REMOTE_NODE=$FIXED_ONE_LIST
REMOTE_NODE_ITFC=$FIXED_ONE_LIST_ITFC
echo $0 : $MYIP remote to $REMOTE_NODE and $REMOTE_NODE_ITFC:  executing at `date`

if [ $1 -eq 1 ] ; then
   echo mkfifo /tmp/packet_capture
   mkfifo /tmp/packet_capture
elif [ $1 -eq 2 ] ; then
   ssh $REMOTE_NODE "tcpdump -s 0 -U -n -w - -i $REMOTE_NODE_ITFC not port 22" > /tmp/packet_capture
elif [ $1 -eq 3 ] ; then
   echo sudo wireshark -k -i /tmp/packet_capture
   sudo wireshark -k -i /tmp/packet_capture
else
   echo Error, $0 expects 1 input param of value 1 thru 3, exiting with no action...
fi
