#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################


TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

echo; echo $0 : $MYIP :  executing at `date`; echo


###################################################################################
# Note: this provides the 7 line examples of user code of tagaUtilsDir/confirm.sh
# cut and paste 7 lines below to your code as necessary
# note that the exit may be replaced with continue or break as necessary in user code
###################################################################################

############# 7 lines begin here #############
# provide the info to print into the confirmation request
InfoToPrint="$0 Put Your Info To Print Here. $0 "
# issue confirmation prompt and check reponse
$tagaUtilsDir/confirm.sh $0 "$InfoToPrint"
response=$?; if [ $response -ne 1 ]; then exit; fi
############# 7 lines end here #############


# continue to execute the command
echo $0 Proceeding.... at `date`; echo


