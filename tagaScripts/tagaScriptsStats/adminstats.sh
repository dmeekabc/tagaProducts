#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

if [ $# -eq 1 ]; then
   if [ $1 == "RXonly" ]; then
      ifconfig $INTERFACE | grep "RX bytes" | cut -d: -f 2 | cut -d\( -f 1
   elif [ $1 == "TXonly" ]; then
      ifconfig $INTERFACE | grep "TX bytes" | cut -d: -f 3 | cut -d\( -f 1
   else
      echo IP Usage: $INTERFACE: `ifconfig $INTERFACE | grep RX | grep bytes`
   fi
else
  #echo 4
  echo IP Usage: $INTERFACE: `ifconfig $INTERFACE | grep RX | grep bytes`
fi

