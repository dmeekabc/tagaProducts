#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

caller=$1
printInfo=$2

#####################################################3
# issuePrompt function
#####################################################3
function issuePrompt {
echo
echo Please Confirm to Proceed.
echo
echo Confirm? \(y/n\) \?
echo

read input

#echo hi
#echo $input                          
#echo $input                          
#echo $input                          
#echo $input                          
#echo hi

if [ $input == "y" ]; then
  return 1 # confirmed
else
  return 2 # not confirmed
fi
}

#####################################################3
# Main
#####################################################3

# print the info
echo
echo $printInfo

# issue the prompt
issuePrompt

# check the response
let response=$?
if [ $response -eq 1 ]; then
  echo; echo Confirmed, $caller continuing....; echo
else
  echo; echo Not Confirmed, $caller exiting or returning with no action...; echo
fi

# return the response to the caller
exit $response

