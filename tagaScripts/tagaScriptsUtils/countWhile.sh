#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

#echo; echo $0 : $MYIP :  executing at `date`; echo

# provide the info to print into the confirmation request
#InfoToPrint="$0 Put Your Info To Print Here. $0 "

# issue confirmation prompt and check reponse
#$tagaUtilsDir/confirm.sh $0 "$InfoToPrint"
#response=$?; if [ $response -ne 1 ]; then exit; fi

# continue to execute the command
#echo $0 Proceeding.... at `date`; echo

FILE_TO_CHECK=$1

# print the input description if exists
#if [ $# -eq 2 ]; then
#   DESCRIPTION=$2
#   # print the param input string
#   printf $DESCRIPTION: 
#fi

let i=0
while true
do
  let i=$i+1

  if [ -f $FILE_TO_CHECK ]; then
    let MODVAL=$i%2
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

