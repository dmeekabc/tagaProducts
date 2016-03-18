#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

caller=$1
printInfo=$2

# print the input before issuing prompt
echo $printInfo

# issue the confirmation prompt
$tagaUtilsDir/confirm.sh

# check the response
let response=$?
if [ $response -eq 1 ]; then
  echo; echo Confirmed, $caller continuing....; echo
else
  echo; echo Not Confirmed, $caller exiting with no action...; echo
fi

exit $response
