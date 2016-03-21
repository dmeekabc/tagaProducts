#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config


# reset our interface
echo Interface is in suspect state - resetting! 
echo Interface is in suspect state - setting interface down!
sudo ifconfig $INTERFACE  down < $TAGA_CONFIG_DIR/passwd.txt
echo Retcode:$?
sleep 5
echo Interface is in suspect state - setting interface up!
sudo ifconfig $INTERFACE  up < $TAGA_CONFIG_DIR/passwd.txt
echo Retcode:$?

