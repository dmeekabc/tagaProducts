#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

CONFIRM_REQD=1

# list of things to strip
STRIP_LIST=`cat $TAGA_DIR/stripList.txt`
ALIAS_FILE=$TAGA_DIR/aliasList.txt
ALIAS_STRIPPED_FILE=$TAGA_DIR/aliasListStripped.txt

echo; echo $0 : $MYIP :  executing at `date`; echo

echo;echo; echo StipList... `ls $TAGA_DIR/stripList.txt 2>/dev/null`

# validate input
echo
echo Keywords :: [ $STRIP_LIST ] 
echo
echo NOTE: The keywords above will be stripped from $ALIAS_FILE 
echo and a new resultant file written to $ALIAS_STRIPPED_FILE
./confirm.sh
let response=$?
if [ $response -eq 1 ]; then
  echo; echo Confirmed, $0 continuing....; echo
else
  echo; echo Not Confirmed, $0 exiting with no action...; echo
  exit
fi

##########################################################
# note, prior to running this script, # run the following: 
#
#    alias > $TAGA_DIR/aliasList.txt
##########################################################

# if confirmation, required, get the confirmation

if [ $CONFIRM_REQD -eq 1 ] ; then
   # ensure proper setup
   echo Please confirm that the following has been performed:
   echo "alias > $ALIAS_FILE"
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

cat $ALIAS_FILE > $ALIAS_STRIPPED_FILE

for item in $STRIP_LIST
do
   cat $ALIAS_STRIPPED_FILE | grep -i -v $item > /tmp/tmp.txt
   cp /tmp/tmp.txt $ALIAS_STRIPPED_FILE
done

echo; echo Created: $ALIAS_STRIPPED_FILE ; echo

