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
sudo iwconfig wlp3s0 essid HOME-7AE2
echo Retcode:$?
sudo iwconfig wlp3s0 key s:X779KUNLRYXFK4CY
echo Retcode:$?
sudo dhclient wlp3s0 
echo Retcode:$?

exit

sudo ifconfig $INTERFACE up
echo Retcode:$?
sudo iwconfig $INTERFACE essid HOME-7AE2
echo Retcode:$?
sudo iwconfig $INTERFACE key s:X779KUNLRYXFK4CY
echo Retcode:$?
sudo dhclient $INTERFACE
echo Retcode:$?


