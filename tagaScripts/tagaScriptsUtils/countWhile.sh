#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

FILE_TO_CHECK=$1

let i=0
while true
do
  let i=$i+1

  if [ -f $FILE_TO_CHECK ]; then
#    let MODVAL=$i%2
    let MODVAL=$i%1
    if [ $MODVAL -eq 0 ]; then
        # sleep before the first print
        sleep 1
      # print once per second while file to check exists
        printf "%d" $i; printf "%c" " " ; sleep 1
    fi
  else
    # file to check does not exist...
    # end the line and exit
    printf "\n" 
    exit
  fi
done

