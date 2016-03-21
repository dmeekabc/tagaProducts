#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

echo
echo Please Confirm to Proceed.
echo
echo Confirm? \(y/n\) ?
echo

read input

if [ $input == "y" ]; then
  echo Confirmed
  exit 1 # confirmed
else
  echo Not Confirmed
  exit 2 # not confirmed
fi


