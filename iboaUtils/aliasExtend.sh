#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

ALIAS_FILE=$TAGA_DIR/aliasExamples.txt
#ALIAS_FILE=$TAGA_DIR/aliasList.txt

# validate input
if [ $# -eq 1 ]; then
   ALIAS_FILE=$1
   echo; echo $0 executing with the following param input... $1; echo
   echo; echo $0 : $MYIP :  executing at `date`; echo
else
   echo; echo $0 executing with no param input...; echo
fi


##########################################################
# note, prior to running this script, # run the following: 
#
#    alias > $TAGA_DIR/aliasList.txt
##########################################################

# if confirmation, required, get the confirmation

#if [ $CONFIRM_REQD -eq 1 ] ; then
if [ true ] ; then
   # ensure proper setup
   echo Please confirm that you would like to extend your aliases by sourcing the follwing file: 
   echo "$ALIAS_FILE"
   # issue confirmation prompt
   ./confirm.sh
   # check the response
   let response=$?
   if [ $response -eq 1 ]; then
     echo; echo Confirmed, $0 continuing....; echo
   else
     echo; echo Not Confirmed, $0 exiting with no action...; echo
     exit
   fi
fi

echo sourcing $ALIAS_FILE;echo
source $ALIAS_FILE
echo Done!;echo

