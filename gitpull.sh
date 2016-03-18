#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

MYDIR=`pwd`

echo; echo $0 : $MYIP :  executing at `date`; echo

# provide the info to print into the confirmation request
InfoToPrint="Pulling via git pull to $MYDIR"
# issue confirmation prompt and check reponse
$tagaUtilsDir/confirm.sh $0 "$InfoToPrint"
response=$?; if [ $response -ne 1 ]; then exit; fi
# execute the command
git pull


