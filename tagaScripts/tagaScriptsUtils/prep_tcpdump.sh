#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

# add a capture group and myself to it
sudo groupadd mypcap
sudo usermod -a -G mypcap $MYLOGIN_ID

# next, change the group of tcpdump and set permissions
sudo chgrp mypcap /usr/sbin/tcpdump
sudo chmod 750 /usr/sbin/tcpdump

# finally, use setcap to give tcpdump the reqd permissions
sudo setcap cap_net_raw,cap_net_admin=eip /usr/sbin/tcpdump

cd /usr/sbin
sudo chmod 777 tcpdump

