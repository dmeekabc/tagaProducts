#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

echo; echo $0 : $MYIP :  executing at `date`; echo

# provide the info to print into the confirmation request
InfoToPrint="$0 Put Your Info To Print Here. $0 "

# issue confirmation prompt and check reponse
$tagaUtilsDir/confirm.sh $0 "$InfoToPrint"
response=$?; if [ $response -ne 1 ]; then exit; fi

# continue to execute the command
echo $0 Proceeding.... at `date`; echo

sudo ifconfig wlp3s0 up
echo Retcode:$?
sudo iwconfig wlp3s0 essid YOUR_SSID_HERE
echo Retcode:$?
sudo iwconfig wlp3s0 key s:YOUR_WIRLESS_NETWORK_KEY_HERE
echo Retcode:$?
sudo dhclient wlp3s0 
echo Retcode:$?

