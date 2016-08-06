#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

echo; echo $0 : $MYIP :  executing at `date`; echo

# tick
$TAGA_UTILS_DIR/tick.sh &

# 2
# mlf alias
cp /opt/jtmnm/largeFilesDir/largeFile2.txt /opt/jtmnm/largeFilesDir/largeFile9.txt

# emr alias
sudo ip route add 224.0.0.0/4 dev wlan0   2>/dev/null        

cd /opt/jtmnm/scripts; cd yangScripts; ./stageJTX.sh `cat /opt/jtmnm/config/contentPath.txt`


# note, stageJTX.sh creates /tmp/tmp.txt conditionally based on inputs

# 2a

# normkill
sudo kill `ps -ef | grep normFileRecv | grep -v grep | cut -c 10-15`
mv /tmp/tmp.txt `cat /opt/jtmnm/config/contentPath.txt`

# 3
cd /opt/jtmnm/scripts; cd yangScripts; ./loadJTX.sh `cat /opt/jtmnm/config/contentPath.txt`


# 4
cd /opt/jtmnm/scripts; cd yangScripts; ./unstageJTX.sh `cat /opt/jtmnm/config/contentPath.txt`


