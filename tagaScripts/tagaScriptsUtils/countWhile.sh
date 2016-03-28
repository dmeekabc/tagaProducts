#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

FILE_TO_CHECK=$1

COUNTWHILE_DAT_FILE=/tmp/countWhile.dat

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
        # print to the terminal only if in EXPERT display mode
        # conditional output to standard out
        if [ $TAGA_DISPLAY_EXPERT -eq 1 ] ; then printf "%d" $i; printf "%c" " " ; fi
        # always print to the log
        # non-conditional output to outfile
        printf "%d" $i >> $COUNTWHILE_DAT_FILE ; printf "%c" " " >> $COUNTWHILE_DAT_FILE 
      #  sleep 1
    fi
  else
    # this is our exit point
    # conditional output to standard out
    # close output to standard out
    # file to check does not exist (no longer exists)... we are done here...
    if [ $TAGA_DISPLAY_EXPERT -eq 1 ] ; then printf "\n"; echo; date; fi
    # non-conditional output to outfile
    # close output to output file
    printf "\n"  >> $COUNTWHILE_DAT_FILE 
    echo         >> $COUNTWHILE_DAT_FILE
    date         >> $COUNTWHILE_DAT_FILE
    # this is our exit point
    exit
  fi
done

